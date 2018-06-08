# [START pub_sub_enqueue]
require "google/cloud/pubsub"
require 'thread'

module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter

      def pubsub
        @pubsub ||= begin
          project_id = Rails.application.secrets.google_pub_sub[:project_id]
          keyfile = Rails.application.config.root + Rails.application.secrets.google_pub_sub[:key_file_path]
          Google::Cloud::Pubsub.new project_id: project_id, keyfile: keyfile
        end
      end

      def jobs_queue
        @jobs_queue ||= Rails.application.secrets.google_pub_sub[:topic]
      end

      def morgue_queue
        @morgue_queue = Rails.application.secrets.google_pub_sub[:morgue_topic]
      end

      def pubsub_subscription
        @pubsub_subscription ||= Rails.application.secrets.google_pub_sub[:subscription]
      end

      def enqueue job
        Rails.logger.info "[PubSubQueueAdapter] enqueue job #{job.inspect}"
        payload = { params: job.arguments, class: job.class.to_s, attempts: 0 }
        publish_message(jobs_queue, payload)
      end

      def publish_message(topic, payload)
        topic = pubsub.topic topic
        topic.publish data: payload.to_json
      end


      def run_worker!
        Rails.logger.info "Running worker to lookup book details"
        topic        = pubsub.topic jobs_queue
        subscription = topic.subscription pubsub_subscription

        mutex = Mutex.new

        subscriber = subscription.listen do |message|
          job_callback(message, mutex)
        end
        subscriber.start
        sleep
      end

      def job_callback(message, mutex)
        message.acknowledge!
        mutex.synchronize { process_job(message, mutex) }
        Thread.current.exit
      end

      def process_job(message, mutex)
        data = JSON.parse(message.attributes["data"])
        begin
          data['attempts'] += 1
          data['class'].constantize.send :perform_now, *data['params']
          puts "#{ data['class'] } Job performed!!"
          Rails.logger.info "#{ data['class'] } Job performed!!"
        rescue Exception => e
          queue = data['attempts'] > 2 ?  morgue_queue : jobs_queue
          publish_message(queue, data)
        end
      end

    end
  end
end

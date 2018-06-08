# [START pub_sub_enqueue]
require "google/cloud/pubsub"

module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter

      def pubsub
        @@pubsub ||= begin
          debugger
          project_id = Rails.application.secrets.google_pub_sub[:project_id]
          keyfile = Rails.application.config.root + Rails.application.secrets.google_pub_sub[:key_file_path]
          Google::Cloud::Pubsub.new project_id: project_id, keyfile: keyfile
        end
      end

      def pubsub_topic
        @@pubsub_topic ||= Rails.application.secrets.google_pub_sub[:topic]
      end

      def pubsub_subscription
        @@pubsub_subscription ||= Rails.application.secrets.google_pub_sub[:subscription]
      end

      def self.enqueue job
        Rails.logger.info "[PubSubQueueAdapter] enqueue job #{job.inspect}"
        payload = { params: job.arguments, class: job.class.to_s }.to_json
        topic = pubsub.topic pubsub_topic
        topic.publish data: payload
      end
# [END pub_sub_enqueue]

      # [START pub_sub_worker]
      def run_worker!
        Rails.logger.info "Running worker to lookup book details"
        topic        = pubsub.topic pubsub_topic
        subscription = topic.subscription pubsub_subscription

        subscriber = subscription.listen do |message|
          message.acknowledge!
          data = JSON.parse(message.attributes["data"])
          data['class'].constantize.send :perform_now, *data['params']
          puts "#{ data['class'] } Job performed!!"
          Rails.logger.info "#{ data['class'] } Job performed!!"
        end

        # Start background threads that will call block passed to listen.
        subscriber.start

        # Fade into a deep sleep as worker will run indefinitely
        sleep
      end
      # [END pub_sub_worker]

    end
  end
end

class NotifySubscribersAboutNewPostJob < ApplicationJob
  queue_as :default

  def perform(post_params)
    load_post(post_params)
    @post.author.subscribers.find_each do |subscriber|
      SubscriberMailer.notify_new_post(subscriber, @post).deliver_later
    end
  end

  private
    def load_post(params)
      @post = Post.find_by(id: params['id'])
    end
end

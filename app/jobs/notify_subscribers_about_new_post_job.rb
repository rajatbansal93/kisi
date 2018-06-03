class NotifySubscribersAboutNewPostJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.author.subscribers.find_each do |subscriber|
      SubscriberMailer.notify_new_post(subscriber, post).deliver_later
    end
  end
end

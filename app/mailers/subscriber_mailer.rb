class SubscriberMailer < ApplicationMailer
  default from: 'notifications@kisi.com'

  def notify_new_post(user, post)
    @user = Subscriber.find_by(id: user["id"])
    @post = Post.find_by(id: post["id"])
    mail(to: @user.email, subject: 'New Post on Kisi!!')
  end
end

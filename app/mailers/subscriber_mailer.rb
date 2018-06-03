class SubscriberMailer < ApplicationMailer
  default from: 'notifications@kisi.com'

  def notify_new_post(user, post)
    @user = user
    @post = post
    mail(to: user.email, subject: 'New Post on Kisi!!')
  end
end

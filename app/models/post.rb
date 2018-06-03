class Post < ApplicationRecord
  #validations
  validates :name, :title, :content, presence: true
  validates :name, uniqueness: true

  #Associations
  belongs_to :author

  #Callbacks
  after_create :notify_subscribers

  private
    def notify_subscribers
      NotifySubscriberAboutNewPostJob.perform_later self
    end
end

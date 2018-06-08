class Post < ApplicationRecord
  #validations
  validates :name, :title, :content, :author, presence: true
  validates :name, uniqueness: true

  #Associations
  belongs_to :author

  #Callbacks
  after_create :notify_subscribers

  private
    def notify_subscribers
      NotifySubscribersAboutNewPostJob.perform_later self
    end
end

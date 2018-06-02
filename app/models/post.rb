class Post < ApplicationRecord
  #validations
  validates :name, :title, :content, presence: true
  validates :name, uniqueness: true

  #Associations
  belongs_to :author

  #Callbacks
  after_create :notify_subscribers
end

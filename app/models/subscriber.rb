class Subscriber < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /.+@.+(\.).+/, message: 'invalid email format' }

  #Associations
  has_and_belongs_to_many :subscriptions,  class_name: 'Author', join_table: 'authors_subscribers'
end

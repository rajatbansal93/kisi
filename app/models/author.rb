class Author < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /.+@.+(\.).+/, message: "invalid email format" }

  #Associations
  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :subscribers
end

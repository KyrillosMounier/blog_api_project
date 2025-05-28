class User < ApplicationRecord
  has_secure_password
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :comments, foreign_key: :user_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end

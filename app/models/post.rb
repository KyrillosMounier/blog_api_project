class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, :body, presence: true
  validate :must_have_at_least_one_tag

  def must_have_at_least_one_tag
    errors.add(:tags, 'must have at least one') if tags.empty?
  end
end

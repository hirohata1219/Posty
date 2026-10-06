class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  scope :search_by_keyword, ->(query) {
    return all if query.blank?
    keywords = query.to_s.strip.split(/\s+/)
    keywords.reduce(all) do |posts, keyword|
      keyword = "%#{sanitize_sql_like(keyword)}%"
      posts.where(
        "title ILIKE :keyword OR body ILIKE :keyword",
        keyword: keyword
      )
    end
  }
end

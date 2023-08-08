# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  before_validation :set_slug, if: -> { title.present? && slug.blank? }

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: true }, format: { with: /\A[a-z0-9\-]+\z/ }

  def set_slug
    self.slug = title.parameterize
  end
end

# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  def token
    JWT.encode({ user_id: id }, Rails.application.secrets.secret_key_base)
  end
end

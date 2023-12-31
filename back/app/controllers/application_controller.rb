# frozen_string_literal: true

class ApplicationController < ActionController::API
  def current_user
    token = request.headers['Authorization']&.split(' ')&.[](1)
    return nil if token.nil?

    User.find_by(id: decode_token(token)['user_id'])
  end

  def admin?
    current_user&.admin?
  end

  def logged_in?
    !!current_user
  end

  def authenticate!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless logged_in?
  end

  private

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true)[0]
  end
end

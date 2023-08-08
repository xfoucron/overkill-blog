# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = user.token
      render json: { token: }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: user.as_json(only: %i[name email]), status: :created
    else
      render json: { errors: user.errors.as_json }, status: :bad_request
    end
  end

  def admin
    if current_user&.admin?
      user = User.find_by(id: params[:user_id])
      if user.update!(admin: !user.admin)
        render json: { message: "User is #{user.admin ? 'admin now' : 'not longer admin'}" }, status: :ok
      else
        render json: { error: user.errors.as_json }, status: :bad_request
      end
    else
      render json: { error: "You're not authorized" }, status: :unauthorized
    end
  end

  def destroy
    user = current_user

    if user&.destroy
      render json: { message: 'Your account has been deleted' }, status: :ok
    else
      render json: { error: 'You are not connected to your account' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end

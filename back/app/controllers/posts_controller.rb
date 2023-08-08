# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[create update destroy]
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.all

    render_post(@posts)
  end

  def show
    render_post(@post)
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      render json: @post.as_json(only: %i[title slug]), status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :slug, :content)
  end

  def render_post(post)
    render json: post.as_json(include: { content: { only: :body }, user: { only: :name } }, only: %i[title slug])
  end
end

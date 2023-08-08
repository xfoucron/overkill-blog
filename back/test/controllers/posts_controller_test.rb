# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @admin_token = users(:admin).token
  end

  test 'should get all posts' do
    get posts_url, as: :json

    assert_equal 2, JSON.parse(@response.body).size
    assert_response :success
  end

  test 'should create post when logged in' do
    assert_difference('Post.count') do
      post posts_url,
           headers: { Authorization: "Bearer #{@admin_token}" },
           params: { post: { title: @post.title, slug: 'im-another-random-slug', content: 'Testing, 1, 1-2' } },
           as: :json
    end

    assert_response :created
  end

  test 'should show post' do
    get post_url(@post), as: :json

    assert_equal @post.title, JSON.parse(@response.body)['title']
    assert_response :success
  end

  test 'should update post when user is logged in and admin' do
    patch post_url(@post),
          headers: { Authorization: "Bearer #{@admin_token}" },
          params: { post: { title: @post.title, slug: 'i-update-the-slug', content: 'Testing, 1, 1-2, 1-2-3' } },
          as: :json

    assert_response :success
  end

  test 'should destroy post when user is logged in and admin' do
    assert_difference('Post.count', -1) do
      delete post_url(@post),
             headers: { Authorization: "Bearer #{@admin_token}" },
             as: :json
    end

    assert_response :no_content
  end
end

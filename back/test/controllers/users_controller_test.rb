# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create an user' do
    post '/api/edge/users/signup', params: { user: { name: 'Jean Claude', email: 'jean@claude.com', password: 'JeanClaude!' } }

    assert_response :success
  end

  test 'should not sign up with a non valid email' do
    post '/api/edge/users/signup', params: { user: { name: 'John Doe', email: 'notvalidemail', password: 'JaneDoeIsASafeMan' } }

    assert_equal ['is invalid'], JSON.parse(@response.body)['errors']['email']
    assert_response :bad_request
  end

  test 'should not sign up with an existing email' do
    post '/api/edge/users/signup', params: { user: { name: 'John Doe', email: 'john@doe.com', password: 'JaneDoeIsASafeMan' } }

    assert_equal ['has already been taken'], JSON.parse(@response.body)['errors']['email']
    assert_response :bad_request
  end

  test 'should not sign up with a weak password' do
    post '/api/edge/users/signup', params: { user: { name: 'John Doe', email: 'john@doe.com', password: 'notsafe' } }

    assert_equal ['is too short (minimum is 8 characters)'], JSON.parse(@response.body)['errors']['password']
    assert_response :bad_request
  end

  test 'should set another user admin' do
    patch "/api/edge/users/admin/#{users(:john).id}", headers: { Authorization: "Bearer #{users(:admin).token}" }

    assert_equal 'User is now admin', JSON.parse(@response.body)['message']
    assert_response :ok
  end

  test 'should set admin user to non admin' do
    patch "/api/edge/users/admin/#{users(:thor).id}", headers: { Authorization: "Bearer #{users(:admin).token}" }

    assert_equal 'User is not longer admin', JSON.parse(@response.body)['message']
    assert_response :ok
  end

  test 'should not be allowed to set an user admin without being admin' do
    patch "/api/edge/users/admin/#{users(:admin).id}", headers: { Authorization: "Bearer #{users(:john).token}" }

    assert_equal "You're not authorized", JSON.parse(@response.body)['error']
    assert_response :unauthorized
  end

  test 'should not be allowed to set an user admin without being logged' do
    patch "/api/edge/users/admin/#{users(:admin).id}"

    assert_equal "You're not authorized", JSON.parse(@response.body)['error']
    assert_response :unauthorized
  end

  test 'should destroy own user account' do
    delete '/api/edge/users/destroy', headers: { Authorization: "Bearer #{users(:john).token}" }

    assert_equal 'Your account has been deleted', JSON.parse(@response.body)['message']
    assert_response :ok
  end

  test 'should not destroy account' do
    delete '/api/edge/users/destroy'

    assert_equal 'You are not connected to your account', JSON.parse(@response.body)['error']
    assert_response :unauthorized
  end
end

# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should create a new session' do
    post '/api/edge/users/login', params: { email: 'john@doe.com', password: 'JohnDoeIsASafeMan' }

    assert_response :success
  end

  test 'should not login with a wrong password' do
    post '/api/edge/users/login', params: { email: 'john@doe.com', password: 'ImNotTheRealPassword' }

    assert_equal 'Invalid email or password', JSON.parse(@response.body)['error']
    assert_response :unauthorized
  end
end

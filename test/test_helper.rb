# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    include ApplicationHelper

    def logged_in?
      !session[:user_id].nil?
    end

    def log_in_as(user)
      session[:user_id] = user.id
    end

    # Add more helper methods to be used by all tests here...
  end
end

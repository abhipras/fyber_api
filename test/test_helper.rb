ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'rails/test_help'

module ActiveSupport
  class TestCase
  end
end
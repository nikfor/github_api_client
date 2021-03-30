require 'bundler/setup'
require_relative 'application_loader'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'])
ApplicationLoader.load_app!
require 'sinatra'
require 'json'
require 'mongoid'

configure do
  Mongoid.load!('./mongoid.yml')
end

require_relative 'customer.rb'
require_relative 'sender.rb'
require_relative 'receiver.rb'

# start listening on server queue
Receiver.new.receive

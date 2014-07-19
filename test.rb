ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative 'service.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "customer" do

  def setup
    Customer.destroy_all
    Customer.create({name: 'customer1', online: false})
    Customer.create({name: 'customer2', online: false})
  end

  it "create" do
    post '/customers', {name: "customer3", online: true}.to_json

    last_response.status.must_equal 201
    Customer.count.must_equal 3
    Customer.last.name.must_equal "customer3"
    Customer.last.online.must_equal true
  end

  it "update online status" do
    put "customers/#{Customer.first.id}", {online: true}.to_json
    Customer.first.online.must_equal true
  end

  it "get all customers" do
    get '/customers'
    last_response.body.must_equal Customer.all.entries.to_json
  end

  it "get information" do
    get "customers/#{Customer.first.id}"
    last_response.body.must_equal Customer.first.to_json
  end

end
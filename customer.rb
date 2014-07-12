require 'sinatra'
require 'json'
require 'mongoid'

configure do
  Mongoid.load!('./mongoid.yml')
end

class Customer
  include Mongoid::Document
end

post '/customers' do
  content_type :json

  Customer.create(JSON.parse(request.body.read))
  status 201
end

get '/customers' do
  content_type :json

  Customer.all.entries.to_json
end

get '/customers/:id' do
  content_type :json

  customer = Customer.where(id: params[:id]).first
  return status 404 if customer.nil?
  customer.to_json
end

put '/customers/:id' do
  content_type :json

  customer = Customer.where(id: params[:id]).first
  return status 404 if customer.nil?
  customer.update_attributes(JSON.parse(request.body.read))
  status 202
end
require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
set :database, 'sqlite3:devmatchbase.sqlite3'
enable :sessions


get '/' do
  erb :index
end

get '/feed' do
  erb :feed
end

get '/signin' do
  erb :signin
end

get '/signup' do
  erb :signup
end

get '/profile' do
  erb :profile
end

get '/settings' do
  erb :settings
end

post '/logout' do
end

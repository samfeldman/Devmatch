require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
set :database, 'sqlite3:devmatchbase.sqlite3'
enable :sessions

post '/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/' do
	erb :index
end

get '/profile' do
	
	@currenttime = Time.new
	
	erb :profile
end

	




#feed page
get '/feed' do
	@posts = Post.all
	erb :feed
end
post '/postnew' do
	if params[:text] = "" #feed textbox is empty
		flash[:emptypost] = "Please enter a post." #flash
	else 
		@post = Post.new(text: params[:text], user_id: session[:user_id])
		@post.save
	end
	redirect '/feed'
end


#signin/up

post '/signin' do
	@user = User.where(email: params[:email]).first
	if @user == User.where(password: params[:password]).first #if the user matches an email and password 
		session[:user_id] = @user.id #add session 
		redirect '/profile' #go to profile page
	else 
		flash[:signinwrong] = "Incorrect email or password. Please re-enter!" #flash
	end
end

post '/signup' do
	@user = User.where(email: params[:email]).first#define the @user as matching a previously made User
	if @user #if the @user exists
		flash[:usedemail] = "Please select a different email." #flash EMAIL HAS BEEN USED ALREADY
	elsif params[:password] !== params[:confirmpassword] #if the password and confirm password don't match
		flash[:diffpassword] = "Your passwords to not match; please re-enter." #flash THEY DONT MATCH YOU TERRIBLE HUMAN YOU CANT TYPE
	else #if the @user doesn't match a User with that email, create a new User
		@user = User.new(fname: params[:fname], lname: params[:lname], email: params[:email], password: params[:password])
		@user.save
	end
	redirect '/profile'
end

#settings page
get '/settings' do
  erb :settings
end



require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
set :database, 'sqlite3:devmatchbase.sqlite3'
enable :sessions



#GENERAL ROUTES/METHODS

get '/' do
	erb :index
end

def current_user
  if session[:user_id].nil?
    @current_user = nil
  else
    @current_user =  User.find(session[:user_id])
  end
  return @current_user
end



#MENU BAR

get '/logout' do
	session[:user_id] = nil
	redirect '/'
end



#PROFILE PAGE

get '/user/:id' do
	current_user
	@user = User.find(params[:id])
	@posts = @user.posts
	erb :profile
end

post '/user/:id/edit' do
	current_user
	@user = User.find(params[:id])
	p params
	p "---------------------------"
	if params[:password] != params[:confirmpassword]
		flash[:user_update] = "Passwords do not match."
		p "not equal"
	elsif @user.id == @current_user.id
		p "user updated"
		@user.update(fname: params[:fname], lname: params[:lname], 
								sex: params[:sex], birthday: params[:birthday], 
								location: params[:location], specialty: params[:specialty], 
								company: params[:company], aboutme: params[:aboutme], 
								email: params[:email], password: params[:password])
	else
		flash[:user_update] = "You do not own this user and cannot alter it."
	end
	redirect "/user/#{ @current_user.id }"
end

get '/user/:id/delete' do
	current_user
	@user = User.find(params[:id])
	if @current_user.id = @user.id
		@user.destroy
		redirect '/'
	else
		flash[:user_delete] = "You are not the signed in user and cannot delete this user."
	end
	redirect_to(:back)
end



#POSTS

post '/postnew' do
	p params
	p session
	if params[:text] = nil #feed textbox is empty
		flash[:emptypost] = "Please enter a post." #flash
	else 
		@post = Post.new(text: params[:text], user_id: session[:user_id])
		@post.save
		flash[:savedpost] = "Post was created"
	end
	redirect '/feed'
end

get '/post/:id/delete' do
	current_user
	@post = Post.find(params[:id])
	if @current_user.id = @post.user_id
		@post.destroy
	else
		flash[:post_delete] = "You do not own this post and cannot delete it."
	end
	redirect_to(:back)
end



#FEED PAGE

get '/feed' do
	erb :feed
end


#SIGNIN/UP

post '/signup' do
	@user = User.where(email: params[:email]).first #define the @user as matching a previously made User
	if @user #if the @user exists
		flash[:usedemail] = "Please select a different email." #flash EMAIL HAS BEEN USED ALREADY
	elsif params[:password] != params[:confirmpassword] #if the password and confirm password don't match
		flash[:diffpassword] = "Your passwords to not match; please re-enter." #flash THEY DONT MATCH YOU TERRIBLE HUMAN YOU CANT TYPE
	else #if the @user doesn't match a User with that email, create a new User
		@user = User.new(fname: params[:fname], lname: params[:lname], email: params[:email], password: params[:password])
		@user.save
		session[:user_id] = @user.id #add session
		current_user
		redirect "/user/#{ @current_user.id }"
	end
	redirect "/"
end

post '/signin' do
	session[:user_id] = nil
	@user = User.where(email: params[:email]).first
	if @user 
		if @user == User.where(password: params[:password]).first #if the user matches an email and password 
			session[:user_id] = @user.id #add session 
			current_user
			redirect "/user/#{ @current_user.id }" #go to profile page
		else 
			flash[:signinwrong] = "Incorrect email or password. Please re-enter!" #flash
		end
	else
		flash[:nouser] = "User does not exist. Please re-enter!" #flash

	end
	redirect "/"
end



#SETTINGS PAGE

get '/settings' do
  erb :settings

end



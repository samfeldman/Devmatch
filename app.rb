require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
require 'pry'
set :database, 'sqlite3:devmatchbase.sqlite3'
enable :sessions



#GENERAL ROUTES/METHODS

def current_user
  if session[:user_id].nil?
    @current_user = nil
  else
    @current_user =  User.find(session[:user_id])
  end
  return @current_user
end

get '/' do
	current_user
	erb :index
end


#MENU BAR

get '/logout' do
	session[:user_id] = nil
	redirect '/'
end



#PROFILE PAGE

get '/user/:id' do
	current_user
	@follow = Follow.where(follower_id: session[:user_id],
                           followee_id: params[:id]).first
	@user = User.find(params[:id])
	@posts = @user.posts
	erb :profile
end

post '/user/:id/edit' do
	current_user
	@user = User.find(params[:id])

	if params[:password] != params[:confirmpassword]
		flash[:user_update] = "passwords do not match, please re-enter."
	elsif @user.id == @current_user.id
		@user.update(fname: params[:fname], lname: params[:lname], 
								sex: params[:sex], birthday: params[:birthday], 
								location: params[:location], specialty: params[:specialty], 
								company: params[:company], aboutme: params[:aboutme], 
								email: params[:email], password: params[:password])
	else
		flash[:user_update] = "you do not own this user and cannot alter it."
	end
	redirect "/user/#{ @current_user.id }"
end

get '/user/:id/delete' do
	current_user
	@user = User.find(params[:id])
	if @current_user.id = @user.id
		@user.posts.destroy_all
		@user.destroy
		redirect '/'
	else
		flash[:user_delete] = "you are not the signed in user and cannot delete this user."
	end
	redirect_to(:back)
end

get '/user/:id/follow' do
	current_user
	@follow = Follow.new(follower_id: session[:user_id], followee_id: params[:id])
	if @follow.save
		flash[:notice] = "you are now following this user."
	else 
		flash[:notice] = "your follow attempt did not work."
	end
	redirect "/user/#{params[:id]}"
end

get '/follow/:id/delete' do
	current_user
	 @follow = Follow.find(params[:id])

	 if @follow.follower_id != session[:user_id]
	 	flash[:notice] = "you may not unfollow."
	 else
	 	if @follow.destroy
	 		flash[:notice] = "you are no longer following this user."
	 	else 
	 		flash[:notice] = "something went wrong :("
	 	end
	 end

  redirect back
end



#POSTS

post '/postnew' do
	current_user
	if params[:text] == "" #feed textbox is empty
		flash[:emptypost] = "please enter a post!" #flash
		redirect "/feed/#{ @current_user.id }"
	else 
		@post = Post.new(text: params[:text], user_id: session[:user_id])
		@post.save
		flash[:savedpost] = "your post was saved!"
	end
	redirect "/feed/#{ @current_user.id }"
end

post '/post/:id/edit' do
	current_user
	@post = Post.find(params[:id])
	if @current_user.id == @post.user_id
		@post.update(text: params[:text])
	else
		flash[:notpostowner] = "you are not the post owner and cannot edit this post."
	end
	redirect back
end

get '/post/:id/delete' do
	current_user
	@post = Post.find(params[:id])
	if @current_user.id = @post.user_id
		@post.destroy
	else
		flash[:post_delete] = "you do not own this post and cannot delete it."
	end
	redirect back
end

#USERS PAGE

get '/userlist' do
	current_user
	@users = User.all
	erb :userlist
end

#FEED PAGE

get '/feed/:id' do
	current_user
	if @current_user 
    	@followers = @current_user.followers
   		@following = @current_user.followees
   		p "------------------------------"
   		p @following 
   		p "----------------------------"
	    if !@following.empty?
	      @following_posts = @following.map(&:posts).flatten #TODO really ugly should fix
	      p @following_posts
	   	p "----------------------------"
	   	p "Hellooooo"
	    else
	      @following_posts = []
	    end
	    p @following_posts
  	end

	@user = User.find(params[:id])
	@posts = Post.all
	erb :feed
end

#SIGNIN/UP

post '/signup' do
	@user = User.where(email: params[:email]).first #define the @user as matching a previously made User
	if @user #if the @user exists
		flash[:usedemail] = "please select a different email." #flash EMAIL HAS BEEN USED ALREADY
	elsif params[:password] != params[:confirmpassword] #if the password and confirm password don't match
		flash[:diffpassword] = "your passwords to not match; please re-enter." #flash THEY DONT MATCH YOU TERRIBLE HUMAN YOU CANT TYPE
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
			flash[:signinwrong] = "incorrect email or password. please re-enter!" #flash
		end
	else
		flash[:nouser] = "user does not exist. please re-enter!" #flash

	end
	redirect "/"
end




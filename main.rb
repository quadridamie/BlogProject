require 'sinatra'
require 'data_mapper'
require 'sinatra/flash'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blogger.db")

configure do
enable :session
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, Text, :required => true, :unique =>true
  property :email, Text, :required => true, :unique =>true
  property :password, Text
  property :created, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
    erb :index
end

post '/register' do
	
  User.create( 
  	:username => params[:username], 
  	:email => params[:email], 
  	:password => params[:password],
    :created => Time.now)
  	if User.create
  	flash[:create] = "User created"
  else
  	flash[:error] = "User not created"
  end
    redirect '/register'
end

get '/dashboard' do
  erb :profile
end

get '/signup' do
  erb :signup
end
get '/login' do
  erb :login
end

post '/login' do
   user = User.first(:username => params[:username])
   if user[:password] == user[:username]
    session[:username] == user[:username]
      redirect '/dashboard'
  else
    redirect '/'
  end
end
get '/logout' do
  session[:username] == nil
  redirect '/'
end
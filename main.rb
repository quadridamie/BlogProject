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
  has n, :posts
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, Text, :required => true, :unique =>true
  property :body, Text, :required => true, :unique =>true
  property :created_at, DateTime
  belongs_to :user
  has n, :comments
end
class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true, :unique =>true
  property :body, Text, :required => true, :unique =>true
  property :created_at, DateTime
  belongs_to :post
end

DataMapper.finalize.auto_upgrade!

get '/' do
    erb :index
end
 get '/test' do
  User.create(:username=>'test name',:email=>'email@yahoo.com',:password => 'test pass')
  @usertest = User.first(:email => 'email@yahoo.com')

  erb :test
 end
post '/register' do
	
  User.create( 
  	:username => params[:username], 
  	:email => params[:email], 
  	:password => params[:password],
    :created => Time.now)
  user = User.first(:email => params[:email])
  if user.nil? 
  flash[:error] = "User Not Created"
  redirect '/signup'
 else
   redirect '/dashboard'
end

    #redirect '/register'
end

get '/dashboard' do
  erb :dashboard
end

get '/signup' do
  erb :signup
end
get '/login' do
  erb :login
end

post '/login' do
   user = User.first(:username => params[:username])
   if !user.nil? && user[:password] == params[:password]
    session[:username] == user[:username]
      redirect '/dashboard'
  else
    flash[:error] = "User Name and passwod Not in existence"
    redirect '/login'
  end
end
get '/logout' do
  session[:username] == nil
  redirect '/'
end
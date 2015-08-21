require 'sinatra'
require 'data_mapper'
require 'sinatra/flash'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blogger.db")


enable :session


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
  property :title, Text, :required => true
  property :body, Text, :required => true 
  property :created, DateTime
  belongs_to :user
  has n, :comments
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true 
  property :body, Text, :required => true
  property :created, DateTime
  belongs_to :post
end

DataMapper.finalize
DataMapper.auto_upgrade!


get '/' do
    erb :index
end
=begin
  
rescue Exception => e
  
end
get '/test' do
  User.create(:username=>'test name',:email=>'email@yahoo.com',:password => 'test pass')
  @usertest = User.first(:email => 'email@yahoo.com')

  erb :test
 end
=end

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
get'/editor' do
erb :editor
end

post '/editor' do
   #  if session[:username].nil?
   #    halt "Access denied, please <a href='/login'>login</a>."
   # end
  Post.create(
    :title => params[:title],
    :body => params[:body],
    :user_id => 1,
    :created => Time.now
   )
    redirect '/dashboard'
end
post '/comments'do
    Comment.create(
      :name => params[:name],
      :body => params[:body],
      :Created => Time.now
      )

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
    session[:username] = params[:username]
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
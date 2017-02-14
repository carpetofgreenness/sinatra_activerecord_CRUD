require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"
require "faker"

set :database, "sqlite3:test.sqlite3"
enable :sessions

get '/' do
  my_name = Faker::HarryPotter.character
  p my_name
  email = my_name.gsub(/[^0-9a-z]/i, "") + "@" + Faker::HarryPotter.location.gsub(/[^0-9a-z]/i, "") + ".com"
  User.create(name: my_name, email: email, profpic: Faker::Avatar.image, quote: Faker::HarryPotter.quote, password: Faker::Superhero.power)
  @users = User.all
  erb :index
end

post '/sign-in' do
  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    redirect "/profile/#{@user.id}"
  else
    flash[:notice] = "Sorry, your login didn't work. Try again"
    redirect '/'
  end
end

get '/profile/:id' do
  @user = User.find(params[:id])
  erb :profile
end

get "/sign-out" do
  session.clear
  flash[:notice] = "You've successfully signed out!"

  redirect "/"
end

get "/user/delete/:id" do
  user = User.find(params[:id])
  user.destroy

  redirect "/"
end
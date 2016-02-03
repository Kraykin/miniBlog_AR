#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:minblog.db"

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end

get '/' do
	@posts = Post.order 'created_at DESC'
	erb :index	
end

get '/new' do
	erb :new
end

post '/new' do
	@new_post = Post.new params[:post]
	@new_post.save
	redirect to '/'
end
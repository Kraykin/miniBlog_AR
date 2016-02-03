#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:minblog.db"

class Post < ActiveRecord::Base
	has_many :comments
end

class Comment < ActiveRecord::Base
	belongs_to :post
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

get '/post/:post_id' do
	@post = Post.find params[:post_id]

	erb :post
end

post '/post/:post_id' do
	params[:comment].store :post_id, params[:post_id]
	@new_comment = Comment.new params[:comment]
	@new_comment.save
	
	redirect to '/post/' + params[:post_id]
end
#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:minblog.db"

class Post < ActiveRecord::Base
	has_many :comments
	validates :username, presence: true
	validates :post, presence: true
end

class Comment < ActiveRecord::Base
	belongs_to :post
	validates :username, presence: true
	validates :comment, presence: true
end

get '/' do
	@posts = Post.order 'created_at DESC'
	erb :index	
end

get '/new' do
	@new_post = Post.new
	erb :new
end

post '/new' do
	@new_post = Post.new params[:post]
	if @new_post.save
		redirect to '/'
	else
		@error = @new_post.errors.full_messages.first
		erb :new
	end
end

get '/post/:post_id' do
	@post = Post.find params[:post_id]
	@comments = Post.find(params[:post_id]).comments.order 'created_at'
	@new_comment = Comment.new
	erb :post
end

post '/post/:post_id' do
	params[:comment].store :post_id, params[:post_id]
	@new_comment = Comment.new params[:comment]
	if @new_comment.save
		redirect to '/post/' + params[:post_id]
	else
		@error = @new_comment.errors.full_messages.first
		redirect to '/post/' + params[:post_id]
	end
end
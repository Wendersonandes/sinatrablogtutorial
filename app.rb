require 'sinatra'
require 'sinatra/activerecord'
require './enviroments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

class Post < ActiveRecord::Base
	validates :title, :presence => true, :length => { :minimum => 5 }
	validates :body, :presence => true
end

get '/' do
	@posts = Post.order("created_at DESC")
	@title = "Welcome."
	erb :"posts/index"
end

get '/posts/create' do
	@post = Post.new
	@title = "Create Post"
	erb :"posts/create"
end

post '/posts' do
	@post = Post.new(params[:post])
	if @post.save
		redirect "posts/#{@post.id}"
	else
		erb :"posts/create"
	end
end

get '/posts/:id' do
	@post = Post.find(params[:id])
	@title = @post.title
	erb :"posts/show"
end

helpers do
	def title
		if @title
			#{@title}
		else
			"Welcome."
		end
	end
end

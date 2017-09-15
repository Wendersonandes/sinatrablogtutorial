require 'sinatra'
require 'sinatra/activerecord'
require './enviroments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

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
		redirect "posts/#{@post.id}", :notice => "Congrats! What a wonderfull new post!! (This message will disappear in 4 seconds)"
	else
		redirect "posts/create", :error => "Something went terrible wrong. Try again...(This message will disappear in 4 seconds)"
	end
end

get '/posts/:id' do
	@post = Post.find(params[:id])
	@title = @post.title
	erb :"posts/show"
end

get '/posts/:id/edit' do
	@post = Post.find(params[:id])
	@title = "Edit form"
	erb :"posts/edit"
end

put '/posts/:id' do
	@post = Post.find(params[:id])
	@post.update(params[:post])
	redirect "posts/#{@post.id}"
end

helpers do

	include Rack::Utils
	alias_method :h, :escape_html

	def title
		if @title
			#{@title}
		else
			"Welcome."
		end
	end
end

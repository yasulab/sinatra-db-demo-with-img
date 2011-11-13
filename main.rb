# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'shotgun'
require 'dm-core'
require 'dm-migrations'

# Path to refer to static contents (e.g. Image)
set :public, File.dirname(__FILE__) + '/public'

DataMapper.setup(:default, 'sqlite3:db.sqlite3')

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :tweet_num, Integer
  property :image_path, String
  property :created_at, DateTime
  auto_upgrade!
end

# Show records in the database
get '/' do
  @posts = []
  #Post.all.map { |r| 
  #  @posts << "#{r.id}, #{r.tweet_num}, \
  #             #{r.created_at}, #{r.title}, #{r.image_path}"
  #}

  Post.all.map {  |r|
    @posts << r
  }
  haml :index
end

# Upload URI to post
post '/upload' do
  if params[:file]
    save_path = "./public/images/#{params[:file][:filename]}"
    File.open(save_path, 'wb') do |f|
      p params[:file][:tempfile]
      f.write params[:file][:tempfile].read
      @mes = "Upload succeeded."
    end
    @image_path = "#{params[:file][:filename]}"
  else
    @mes = "Upload failed."
    @image_path = "sample.jpg"
  end
  post = Post.create(
                     :title => "Hello world! via '/upload'.",
                     :tweet_num => 0,
                     :image_path => @image_path,
                     :created_at => Time.now
                     )
  haml :upload
  redirect '/'
end

get '/create' do
  post = Post.create(
                     :title => "Hello world via '/create'.",
                     :tweet_num => 0,
                     :image_path => "sample.jpg",
                     :created_at => Time.now
                     )
  "Post.create was created!" unless post.nil? # If fail => nil ?
end


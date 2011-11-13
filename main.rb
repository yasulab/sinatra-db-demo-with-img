# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'shotgun'
require 'dm-core'
require 'dm-migrations'

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

get '/' do
  Post.all.map { |r| "#{r.id}, #{r.tweet_num}, #{r.created_at}, #{r.title}, #{r.image_path} <br>"}
end

get '/create' do
  post = Post.create(
                     :title => "DataMapperからHello world!",
                     :tweet_num => 0,
                     :created_at => Time.now
                     )
  "Post.createに成功!" unless post.nil? # 失敗したらnil???
end


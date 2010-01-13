require 'rubygems'
require 'sinatra'
require 'helper'
require 'dictionary'

get '/' do
  @dict_list = Dictionary.all(:order => [:word])
  erb :index
end

get '/word/:target' do
  @dict = Dictionary.first(:word => params[:target])
  redirect '/' unless @dict
  erb :word
end

# admin -------------------------------------------------------------

get '/login' do
  user = current_user

  unless user
    redirect AppEngine::Users.create_login_url('/')
  end

  redirect '/'
end

get '/admin/?' do
  need_admin
  @dict_list = Dictionary.all(:order => [:word])
  erb :admin
end

get '/admin/add' do
  need_admin
  erb :add
end

get '/admin/update/:id' do
  need_admin
  @dict = Dictionary.get(params[:id])
  to_admin unless @dict
  erb :update
end

post '/admin/regist_word' do
  need_admin

  word = params[:word].trim_space
  to_admin if word.blank?

  @dict = Dictionary.first(:word => word)
  unless @dict
    @dict = Dictionary.new
    @dict.word = word
  end
  
  count = params[:count].to_i
  count = 5 if count <= 0
  (1..count).each do |i|
    exp = params["exp_#{i}".to_sym].trim_space
    next if exp.blank? 
    @dict.add_explanation(exp)
  end
  
  @dict.before_save
  @dict.save!
  to_admin
end

get '/admin/delete/:id' do
  need_admin
  @dict = Dictionary.get(params[:id])
  to_admin unless @dict
  @dict.destroy!
  to_admin
end

# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class Memo
  def self.prepare_db
    return if @connection

    @connection = PG.connect(dbname: 'memoapp')
    @connection.prepare('all', 'SELECT * FROM posts ORDER BY id asc;')
    @connection.prepare('create', 'INSERT INTO posts(title, body) VALUES ($1, $2)')
    @connection.prepare('find', 'SELECT * FROM posts WHERE id = $1')
    @connection.prepare('update', 'UPDATE posts SET (title, body) = ($2, $3) WHERE id = $1')
    @connection.prepare('destroy', 'DELETE FROM posts WHERE id = $1')
  end

  def self.all_memos
    @connection.exec_prepared('all')
  end

  def self.create_memo(title: memo_title, body: memo_body)
    @connection.exec_prepared('create', [title, body])
  end

  def self.find_memo(id: memo_id)
    @connection.exec_prepared('find', [id]) { |result| result[0] }
  end

  def self.update_memo(id: memo_id, title: memo_title, body: memo_body)
    @connection.exec_prepared('update', [id, title, body])
  end

  def self.destroy_memo(id: memo_id)
    @connection.exec_prepared('destroy', [id])
  end
end

before do
  Memo.prepare_db
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @title_head = 'top'
  @memo = Memo.all_memos
  erb :index
end

get '/memos/new' do
  @title_head = 'new'
  erb :new
end

get '/memos/:id' do
  @title_head = 'show'
  @memo = Memo.find_memo(id: params[:id])
  erb :show
end

post '/memos' do
  Memo.create_memo(title: params[:title], body: params[:body])
  redirect '/'
end

get '/memos/:id/edit' do
  @title_head = 'edit'
  @memo = Memo.find_memo(id: params[:id])
  erb :edit
end

put '/memos/:id' do
  Memo.update_memo(id: params[:id], title: params[:title], body: params[:body])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  Memo.destroy_memo(id: params[:id])
  redirect '/'
end

not_found do
  'ファイルが存在しません'
end

helpers do
  def h(str)
    Rack::Utils.escape_html(str)
  end
end

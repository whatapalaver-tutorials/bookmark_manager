require 'sinatra/base'
require 'sinatra/flash'
require './lib/bookmark'
require 'uri'

# This controller class
class BookmarkManager < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    redirect '/bookmarks'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all 
    erb :index
  end

  get '/bookmarks/new' do
    erb :'bookmarks/new'
  end

  post '/bookmarks' do
    bookmark = Bookmark.create(params)
    flash[:notice] = 'You must submit a valid URL.' unless bookmark
    redirect '/bookmarks'
  end

  post '/bookmarks/:id/delete' do
    Bookmark.delete(params['id'])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark_id = params['id']
    erb :"bookmarks/edit"
  end

  post '/bookmarks/:id' do
    connection = PG.connect(dbname: 'bookmark_manager_test')
    connection.exec("UPDATE bookmarks SET url = '#{params['url']}', title = '#{params['title']}' WHERE id = '#{params['id']}'")
    redirect('/bookmarks')
  end

  run! if app_file == $PROGRAM_NAME
end

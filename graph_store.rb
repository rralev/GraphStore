require 'sinatra'
require 'json'

before do
    content_type 'application/json'
end

get '/' do
  "List all graphs"
  #TODO: OR list documentation
end

#TODO: List all graph names
get '/list' do #or /graphs
  "list"
end

#TODO: add new graph
post '/new' do
  "new"
end

#TODO: rename existing graph
put '/rename' do
  "rename"
end

#TODO: delete graph
delete '/delete' do
  "delete"
end

#TODO:search graph
get '/search/:name' do
  "search"
end

#TODO: add edge
post '/add/edge' do
end

#TODO: add vertex
post '/add/vertex' do
end

#TODO: delete edge
delete '/delete/edge' do
end

#TODO: delete vertex
delete '/delete/vertex' do
end

#TODO: update edge
put '/update/edge' do
end

#TODO: update vertex
put '/update/vertex' do
end

#TODO: serch vertex
get '/search/vertex/:name' do
end

#TODO: serch vertex
get '/search/vertex/:u/:v' do
end

#TODO: and more alghorithms

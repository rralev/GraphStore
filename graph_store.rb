require 'sinatra'
require 'json'

before do
    content_type 'application/json'
end

get '/' do
  "List api info/documentation"
  #TODO: OR list documentation
end

#TODO: List all graph names
get '/list' do #or /graphs
  "list"
end

#TODO: add new graph
#after that add nodes and edges
post '/new' do
  graph_name = params[:name]
  File.write(graph_name, params.to_json)
end

#TODO: rename existing graph
put '/rename' do
  old_name = params[:old_name]
  new_name = params[:new_name]
  File.rename(old_name, new_name)
end

#TODO: delete graph
delete '/delete' do
  graph_name = params[:name]
  File.delete(graph_name)
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

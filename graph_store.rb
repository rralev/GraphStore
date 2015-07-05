require 'sinatra'
require 'json'

before do
    content_type 'application/json'
end

#TODO: other message when request is not found ex: post delete
not_found do
  {error: "Graph not found!"}.to_json
end

error 400 do
  {error: "Invalid request!"}.to_json
end

error 409 do
  {error: "Graph with provided name already exists!"}.to_json
end

error 500...600 do
  {error: "Internal server error!"}.to_json
end

#TODO:documentation
get '/' do
  "documentation"
end

get '/list' do
  graph_names = Dir["graphs/*"].map { |file|
    File.basename(file)
  }
  {graphs: graph_names}.to_json
end

post '/new' do
  graph_name = params[:name]

  halt 400 if graph_name == nil

  graph_name = "graphs/#{graph_name}"
  if File.exist?(graph_name)
    halt 409
  else
    File.write(graph_name, params.to_json)
  end

  200
end

put '/rename' do
  old_name = params[:old_name]
  new_name = params[:new_name]

  halt 400 if old_name == nil || new_name == nil

  old_name = "graphs/#{old_name}"
  new_name = "graphs/#{new_name}"

  if File.exist?(old_name)
    File.rename(old_name, new_name)
  else
    halt 404
  end

  200
end

delete '/delete' do
  graph_name = params[:name]

  halt 400 if graph_name == nil

  graph_name = "graphs/#{graph_name}"

  if File.exist?(graph_name)
    File.delete(graph_name)
  else
    halt 404
  end

  200
end

get '/search/:query' do
  query = params[:query]
  halt 400 if query == nil
  #query.downcase! Ask Agi for it

  graphs_names = Dir["graphs/*#{query}*"].map { |file|
    File.basename(file)
  }

  {graphs: graphs_names}.to_json
end

#TODO: 1 -> 2 ; 1 -> 3
post '/add/edge' do
  graph_name = params[:graph_name]
  u = params[:u]
  v = params[:v]
  halt 400 if graph_name == nil || u == nil || v == nil

  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  graph[u] = [] if graph[u] == nil
  graph[u].push(v)
  File.write(file, graph.to_json)

  200
end

#TODO: combine with the method above
post '/add/vertex' do
  graph_name = params[:graph_name]
  u = params[:u]
  halt 400 if graph_name == nil || u == nil

  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  halt 400 if graph[u] != nil
  graph[u] = []
  File.write(file, graph.to_json)

  200
end

#deletes all 1 -> 2, 1 -> 2
delete '/delete/edge' do
  graph_name = params[:graph_name]
  u = params[:u]
  v = params[:v]
  halt 400 if graph_name == nil || u == nil || v == nil
  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  halt 400 if graph[u] == nil
  graph[u].delete(v)
  File.write(file, graph.to_json)

  200
end

delete '/delete/vertex' do
  graph_name = params[:graph_name]
  u = params[:u]
  halt 400 if graph_name == nil || u == nil
  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  graph.delete(u)
  graph.map { |_key, value|
    value.delete(u)
  }
  File.write(file, graph.to_json)

  200
end

#TODO: we can provide vertex that does not exist
put '/update/edge' do
  graph_name = params[:graph_name]
  u = params[:u]
  v = params[:v]
  new_u = params[:new_u]
  new_v = params[:new_v]

  halt 400 if graph_name == nil || u == nil || v == nil || new_u == nil || new_v == nil
  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  halt 400 if graph[u] == nil || !graph[u].include?(v)
  graph[u].map! { |e|
    e == v ? new_v : e
  }
  graph[new_u] = graph[u]
  graph.delete(u)
  File.write(file, graph.to_json)
end

#TODO: update vertex
put '/update/vertex' do
end

#TODO: serch vertex
get '/search/vertex/:name' do
end

#TODO: serch edge
get '/search/vertex/:u/:v' do
end

#TODO: and more alghorithms

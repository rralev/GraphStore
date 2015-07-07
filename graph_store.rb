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
    File.write(graph_name, "{}")
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
  graph[v] = [] if graph[v] == nil
  graph[u].push(v)
  File.write(file, graph.to_json)

  200
end

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

put '/update/edge' do
  graph_name = params[:graph_name]
  u = params[:u]
  v = params[:v]
  new_v = params[:new_v]
  halt 400 if graph_name == nil || u == nil || v == nil || new_v == nil

  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  halt 400 if graph[u] == nil || !graph[u].include?(v)
  graph[u].map! { |e|
    e == v ? new_v : e
  }
  File.write(file, graph.to_json)

  200
end

put '/update/vertex' do
  graph_name = params[:graph_name]
  u = params[:u]
  new_u = params[:new_u]
  halt 400 if graph_name == nil || u == nil || new_u == nil

  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  halt 400 if graph[u] == nil || graph[new_u] != nil
  graph[new_u] = graph[u]
  graph.delete(u)

  graph.each { |key, list|
     list.map! { |v|
       v == u ? new_u : v
     }
  }
  File.write(file, graph.to_json)

  200
end

get '/search/vertex/:graph_name/:u' do
  graph_name = params[:graph_name]
  u = params[:u]
  halt 400 if graph_name == nil || u == nil
  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  graph = JSON.parse(File.read(file))
  graph[u] == nil ? false.to_json : true.to_json
end

get '/search/edge/:u/:v' do
end

#TODO: and more alghorithms

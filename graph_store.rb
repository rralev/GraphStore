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

  graph = get_graph(graph_name)
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

  graph = get_graph(graph_name)
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

  graph = get_graph(graph_name)
  halt 400 if graph[u] == nil
  graph[u].delete(v)
  File.write(file, graph.to_json)

  200
end

delete '/delete/vertex' do
  graph_name = params[:graph_name]
  u = params[:u]
  halt 400 if graph_name == nil || u == nil

  graph = get_graph(graph_name)
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

  graph = get_graph(graph_name)
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

  graph = get_graph(graph_name)
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

  graph = get_graph(graph_name)
  graph[u] == nil ? false.to_json : true.to_json
end

get '/search/edge/:graph_name/:u/:v' do
  graph_name = params[:graph_name]
  u = params[:u]
  v = params[:v]
  halt 400 if graph_name == nil || u == nil || v == nil

  graph = get_graph(graph_name)
  graph[u] != nil && graph[u].include?(v) ? true.to_json : false.to_json
end

get '/dfs/:graph_name/:vertex' do
  graph_name = params[:graph_name]
  vertex = params[:vertex]
  halt 400 if graph_name == nil

  $used = {}
  $list = []
  $graph = get_graph(graph_name)
  dfs(vertex)

  $list.to_json
end

get '/bfs/:graph_name/:vertex' do
  graph_name = params[:graph_name]
  vertex = params[:vertex]
  halt 400 if graph_name == nil

  graph = get_graph(graph_name)
  bfs(graph, vertex).to_json
end

def get_graph(graph_name)
  file = "graphs/#{graph_name}"
  halt 404 if !File.exist?(file)
  JSON.parse(File.read(file))
end

def dfs(u)
  $used[u] = 1
  $list << u

  $graph[u].each { |v|
    dfs(v) if $used[v] == nil
  } if $graph[u] != nil

  $used[u] = 2
end

def bfs(graph, vertex)
  queue = Queue.new
  queue << vertex
  used = {}
  used[vertex] = 1
  list = []

  while queue.size > 0 do
    front = queue.pop
    list << front

    graph[front].each { |v|
      if used[v] == nil
        queue << v
        used[v] = 1
      end
    } if graph[front] != nil
  end

  list
end

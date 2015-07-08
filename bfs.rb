class Bfs
  def initialize(graph)
    @graph = graph
    @used = {}
    @pred = {}
  end

  def compute(vertex)
    queue = Queue.new
    queue << vertex
    @used[vertex] = 1
    @pred[vertex] = vertex
    list = []

    while queue.size > 0 do
      front = queue.pop
      list << front

      @graph[front].each { |v|
        if @used[v] == nil
          queue << v
          @used[v] = 1
          @pred[v] = front
        end
      } if @graph[front] != nil
    end

    list
  end

  def get_path_between_two_vertices(u, v)
    compute(u)
    list = []

    vertex = v
    while vertex != @pred[vertex] do
      list << vertex
      vertex = @pred[vertex]
    end
    list << vertex

    list.reverse
  end
end

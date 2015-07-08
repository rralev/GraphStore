class Bfs
  def initialize(graph)
    @graph = graph
  end

  def compute(vertex)
    queue = Queue.new
    queue << vertex
    used = {}
    used[vertex] = 1
    list = []

    while queue.size > 0 do
      front = queue.pop
      list << front

      @graph[front].each { |v|
        if used[v] == nil
          queue << v
          used[v] = 1
        end
      } if @graph[front] != nil
    end

    list
  end
end

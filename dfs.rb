class Dfs
  def initialize(graph)
    @used = {}
    @list = []
    @graph = graph
    @path = []
    @cycles = []
  end

  def compute(vertex)
    dfs(vertex)
    @list
  end

  def get_cycles
    @cycles
  end

  private
  def dfs(u)
    @used[u] = 1
    @list << u
    @path << u

    @graph[u].each { |v|
      if @used[v] == nil
        dfs(v)
        @path.pop
      elsif @used[v] == 1
        @cycles << @path.flatten
      end
    } if @graph[u] != nil

    @used[u] = 2
  end
end

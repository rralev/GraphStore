class Dfs
  def initialize(graph)
    @used = {}
    @list = []
    @graph = graph
  end

  def compute(vertex)
    dfs(vertex)
    @list
  end

  private
  def dfs(u)
    @used[u] = 1
    @list << u

    @graph[u].each { |v|
      dfs(v) if @used[v] == nil
    } if @graph[u] != nil
  end
end

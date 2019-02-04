# PROMPT:
# There is a new alien language which uses the latin alphabet. However, the order among letters are
# unknown to you. You receive a list of non-empty words from the dictionary, where words are sorted 
# lexicographically by the rules of this new language. Derive the order of letters in this language.


def start_graph(words)
  # initialize graph and edge count
  g = nodeset(words)
  gk = g.keys

  # initialize edge count
  incoming_edges = {}
  gk.each { |k| incoming_edges[k] = 0 }

  words.each_with_index do |w, i|
    w2 = words[i + 1]
    unless i + 1 == words.length
      # grab adjacent words in the dict and split them into arrays of their characters
      chars1, chars2 = w.split(""), w2.split("")
      chars1.each_with_index do |c, j|
        # compare characters in the words
        c2 = chars2[j]
        next if c == c2
        # note the parent/child relationship and increment the in-degree count
        g[c] += c2
        incoming_edges[c2] += 1
        break
      end
    end
  end

  alienlang(g, incoming_edges)
end

# get nodes from words
def nodeset(words, h = {})
  words.each do |w|
    chars = w.split("")
    chars.each { |c| h[c] = "" }
  end

  h
end

# implement kahn's algo for topological sort
def alienlang(graph, in_degrees)
  g, deg, visited, solution = graph, in_degrees, 0, []

  # enqueue all vertices with an in-degree of 0
  queue = []
  deg.each do |k, v|
    if v == 0
      queue << k
      deg.delete(k)
    end
  end

  # until que is empty
  until queue.empty?
    solution << queue.shift
    visited += 1

    # traverse graph and remove edges
    parent = solution.last
    child = g[parent]
    # update in-degree count
    if deg.include?(child)
      deg[child] -= 1
      if deg[child] == 0 
        queue << child
        deg.delete(child)
      end
    end
  end

  g.length == visited ? solution : ""
end

# Tests #
puts start_graph(["wrt", "wrf", "er", "ett", "rftt"])
puts ""
puts start_graph(["z", "x"])
puts ""
puts start_graph(["z", "x", "z"])
puts ""
puts start_graph(["wrt","wrf","er","ef"])
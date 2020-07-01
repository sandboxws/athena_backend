module Graph
  module Connections
    class SqlQueriesConnection < Graph::Connections::BaseConnection
      edge_type(Graph::Edges::SqlQueriesEdge)
    end
  end
end

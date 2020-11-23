module Graph
  module Edges
    class SqlQueriesEdge < GraphQL::Types::Relay::BaseEdge
      node_type(Graph::Types::SqlQuery)
    end
  end
end

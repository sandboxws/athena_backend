module Graph
  module Connections
    class StacktracesEdge < GraphQL::Types::Relay::BaseEdge
      node_type(Graph::Types::Stacktrace)
    end
  end
end

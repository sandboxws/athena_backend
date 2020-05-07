module Graph
  module Connections
    module Mongodb
      class StacktracesEdge < GraphQL::Types::Relay::BaseEdge
        node_type(Graph::Types::Mongodb::Stacktrace)
      end
    end
  end
end

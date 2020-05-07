module Graph
  module Connections
    module Mongodb
      class LogsEdge < GraphQL::Types::Relay::BaseEdge
        node_type(Graph::Types::Mongodb::Log)
      end
    end
  end
end

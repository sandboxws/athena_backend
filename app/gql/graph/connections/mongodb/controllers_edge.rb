module Graph
  module Connections
    module Mongodb
      class ControllersEdge < GraphQL::Types::Relay::BaseEdge
        node_type(Graph::Types::Mongodb::Controller)
      end
    end
  end
end

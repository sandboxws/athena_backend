module Graph
  module Connections
    class ControllersEdge < GraphQL::Types::Relay::BaseEdge
      node_type(Graph::Types::Controller)
    end
  end
end

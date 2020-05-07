module Graph
  module Edges
    class ControllerEdge < Graph::Types::BaseEdge
      node_type(Graph::Types::Mongodb::Controller)
    end
  end
end

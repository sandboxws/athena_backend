module Graph
  module Connections
    class ControllersConnection < Graph::Connections::BaseConnection
      edge_type(ControllersEdge)
    end
  end
end

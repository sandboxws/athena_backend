module Graph
  module Connections
    module Mongodb
      class ControllersConnection < Graph::Connections::BaseConnection
        edge_type(ControllersEdge)
      end
    end
  end
end

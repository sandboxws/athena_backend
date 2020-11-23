module Graph
  module Connections
    class AwesomeControllersConnection < Graph::Connections::BaseConnection
      edge_type(Graph::Edges::AwesomeController)
    end
  end
end

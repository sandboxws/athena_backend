module Graph
  module Connections
    module Mongodb
      class LogsConnection < Graph::Connections::BaseConnection
        edge_type(LogsEdge)
      end
    end
  end
end

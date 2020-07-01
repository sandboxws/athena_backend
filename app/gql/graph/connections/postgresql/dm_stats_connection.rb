module Graph
  module Connections
    module Postgresql
      class DmlStatsConnection < Graph::Connections::BaseConnection
        edge_type(::Graph::Edges::Postgresql::DmlStatsEdge)
      end
    end
  end
end

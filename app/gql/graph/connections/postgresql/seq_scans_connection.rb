module Graph
  module Connections
    module Postgresql
      class SeqScansConnection < Graph::Connections::BaseConnection
        edge_type(::Graph::Edges::Postgresql::SeqScansEdge)
      end
    end
  end
end

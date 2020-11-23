module Graph
  module Edges
    module Postgresql
      class SeqScansEdge < Graph::Types::BaseEdge
        node_type(::Graph::Types::Postgresql::SeqScan)
      end
    end
  end
end

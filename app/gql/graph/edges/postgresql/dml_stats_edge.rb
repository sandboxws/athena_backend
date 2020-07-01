module Graph
  module Edges
    module Postgresql
      class DmlStatsEdge < Graph::Types::BaseEdge
        node_type(::Graph::Types::Postgresql::DmlStat)
      end
    end
  end
end

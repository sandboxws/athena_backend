module Graph
  module Connections
    module Postgresql
      class SeqScans < Graph::Types::BaseObject
        implements ::Graph::Types::PageableType
        field :nodes, [::Graph::Types::Postgresql::SeqScan], null: false
        def nodes
          object
        end
      end
    end
  end
end

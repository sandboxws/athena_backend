module Graph
  module Connections
    module Postgresql
      class DmlStats < Graph::Types::BaseObject
        implements ::Graph::Types::PageableType
        field :nodes, [::Graph::Types::Postgresql::DmlStat], null: false
        def nodes
          object
        end
      end
    end
  end
end

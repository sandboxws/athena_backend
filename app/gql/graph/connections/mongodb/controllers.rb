module Graph
  module Connections
    module Mongodb
      class Controllers < Graph::Types::BaseObject
        implements Graph::Types::PageableType
        field :nodes, [Graph::Types::Mongodb::Controller], null: false
        def nodes
          object
        end
      end
    end
  end
end

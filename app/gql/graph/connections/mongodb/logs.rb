module Graph
  module Connections
    module Mongodb
      class Logs < Graph::Types::BaseObject
        implements Graph::Types::PageableType
        field :nodes, [Graph::Types::Mongodb::Log], null: false
        def nodes
          object
        end
      end
    end
  end
end

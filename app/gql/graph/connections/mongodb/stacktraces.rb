module Graph
  module Connections
    module Mongodb
      class Stacktraces < Graph::Types::BaseObject
        implements Graph::Types::PageableType
        field :nodes, [Graph::Types::Mongodb::Stacktrace], null: false
        def nodes
          object
        end
      end
    end
  end
end

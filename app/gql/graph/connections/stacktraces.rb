module Graph
  module Connections
    class Stacktraces < Graph::Types::BaseObject
      implements Graph::Types::PageableType
      field :nodes, [Graph::Types::Stacktrace], null: false
      def nodes
        object
      end
    end
  end
end

module Graph
  module Connections
    class Controllers < Graph::Types::BaseObject
      implements Graph::Types::PageableType
      field :nodes, [Graph::Types::Controller], null: false
      def nodes
        object
      end
    end
  end
end

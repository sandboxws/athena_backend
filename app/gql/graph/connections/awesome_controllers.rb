module Graph
  module Connections
    class AwesomeControllers < Graph::Types::BaseObject
      implements Graph::Types::PageableType
      field :nodes, [Graph::Types::AwesomeController], null: false
      def nodes
        object
      end
    end
  end
end

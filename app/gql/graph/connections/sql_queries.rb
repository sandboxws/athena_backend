module Graph
  module Connections
    class SqlQueries < Graph::Types::BaseObject
      implements Graph::Types::PageableType
      field :nodes, [Graph::Types::SqlQuery], null: false
      def nodes
        object
      end
    end
  end
end

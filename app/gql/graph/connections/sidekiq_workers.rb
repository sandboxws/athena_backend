module Graph
  module Connections
    class SidekiqWorkers < Graph::Types::BaseObject
      implements Graph::Types::PageableType
      field :nodes, [Graph::Types::SidekiqWorker], null: false
      def nodes
        object
      end
    end
  end
end

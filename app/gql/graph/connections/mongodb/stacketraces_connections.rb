module Graph
  module Stacktraces
    module Mongodb
      class StacktracesConnection < Graph::Stacktraces::BaseConnection
        edge_type(StacktracesEdge)
      end
    end
  end
end

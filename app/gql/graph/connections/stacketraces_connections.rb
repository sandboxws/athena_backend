module Graph
  module Stacktraces
    class StacktracesConnection < Graph::Stacktraces::BaseConnection
      edge_type(StacktracesEdge)
    end
  end
end

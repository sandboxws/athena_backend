module Graph
  module Connections
    module Mongodb
      class Explains < Graph::Connections::BaseConnection
        field :nodes, [Graph::Types::Mongodb::Explain], null: false do
          argument :limit, Integer, default_value: 25, required: false
        end
      end
    end
  end
end

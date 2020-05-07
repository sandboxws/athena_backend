module Graph
  module Types
    class Stat < Graph::Types::BaseObject
      field :name, type: String, null: false, description: 'Stat name'
      field :value, type: Integer, null: false, description: 'Stat value'
    end
  end
end

module Graph
  module Types
    class TableStats < Graph::Types::BaseObject
      field :name, type: String, null: false, description: 'Table name'
      field :stats, type: [Stat], null: false, description: 'Table stats'
    end
  end
end

module Graph
  module Types
    class CollectionStats < Graph::Types::BaseObject
      field :name, type: String, null: false, description: 'Collection name'
      field :stats, type: [Stat], null: false, description: 'Collection stats'
    end
  end
end

Graph::Connections::Mongodb::Logs
# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class LogsWithStats < Types::BaseObject
        description 'MongoDB Query Logs'
        field :collections, [String], null: false, description: 'MongoDB collections list'
        field :operations, [String], null: false, description: 'MongoDB operations list'
        field :collections_stats, [Stat], null: false, description: 'MongoDB collection stats'
        field :operations_stats, [Stat], null: false, description: 'MongoDB operation stats'
        field :logs, Graph::Connections::Mongodb::Logs, null: false
      end
    end
  end
end

# frozen_string_literal: true

module Graph
  module Types
    class SqlQueriesWithStats < Types::BaseObject
      description 'MongoDB Query Logs'
      field :tables, [String], null: false, description: 'MongoDB tables list'
      field :operations, [String], null: false, description: 'MongoDB operations list'
      field :total_duration, Float, null: false, description: 'Queries total execution duration in seconds'
      field :source_names, [String], null: false, description: 'Source names list'
      field :tables_stats, [Stat], null: false, description: 'MongoDB collection stats'
      field :operations_stats, [Stat], null: false, description: 'MongoDB operation stats'
      field :sql_queries, Graph::Connections::SqlQueries, null: false
    end
  end
end

# frozen_string_literal: true
module Graph
  module Types
    class Stacktrace < Types::BaseObject
      description 'MongoDB Query Stacktrace'

      field :id, ID, null: false, description: 'Stacktrace primary key'
      field :stacktrace, String, null: false, description: 'A minified version of a stacktrace'
      field :stacktrace_excerpt, String, null: true, description: 'A minified version of a stacktrace'
      field :sources_stats, [Stat], null: false, description: 'Sources stats'

      field :logs_count, Integer, null: true, description: 'Total count of logs originating from this stacktrace'
      field :min_duration, Float, null: true, description: 'Min duration for a query originating from this stacktrace'
      field :max_duration, Float, null: true, description: 'Max duration for a query originating from this stacktrace'
      field :avg_duration, Float, null: true, description: 'Average duration for a query originating from this stacktrace'
      field :logs, Graph::Connections::Mongodb::Logs, null: false, description: 'Associated MongoDB Logs'

      field :sql_queries_count, Integer, null: true, description: 'Total count of sql queries originating from this stacktrace'
      field :sql_queries_min_duration, Float, null: true, description: 'Min duration for a query originating from this stacktrace'
      field :sql_queries_max_duration, Float, null: true, description: 'Max duration for a query originating from this stacktrace'
      field :sql_queries_avg_duration, Float, null: true, description: 'Average duration for a query originating from this stacktrace'
      field :sql_queries_sources_stats, [Stat], null: false, description: 'Sources stats'
      field :sql_queries, Graph::Connections::SqlQueries, null: false, description: 'Associated SQL Queries'

      timestamps(self)
    end
  end
end

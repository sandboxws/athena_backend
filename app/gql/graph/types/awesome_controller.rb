# frozen_string_literal: true
module Graph
  module Types
    class AwesomeController < Types::BaseObject
      description 'Awesome Rails Controller'

      field :id, ID, null: false, description: 'Primary key'
      field :name, String, null: false, description: 'Name of a rails controller'
      field :action, String, null: false, description: 'Rails controller action'
      field :path, String, null: false, description: 'Rails controller path'
      field :params, String, null: false, description: 'HTTP request params'
      field :params_excerpt, String, null: false, description: 'Mini version of the HTTP request params'
      field :session_id, String, null: false, description: 'A unique id identifying a session during which queries are logged.'

      field :ops_stats, [Stat], null: true, description: 'Controller stats'
      field :collections_stats, [CollectionStats], null: true, description: 'Controller stats'
      field :collscans, Integer, null: true, description: 'Count of COLLSCAN queries'
      field :logs_count, Integer, null: true, description: 'Total count of logs per action per path'
      field :logs, Graph::Connections::Mongodb::Logs, null: true, description: 'Associated MongoDB Logs'
      field :total_duration, Float, null: true, description: 'Total duraiton of all sql queries'

      field :tables_stats, [TableStats], null: true, description: 'Controller stats'
      field :sql_ops_stats, [Stat], null: true, description: 'Controller stats'
      field :sql_queries_count, Integer, null: true, description: 'Total count of queries per action per path'
      field :sql_total_duration, Float, null: true, description: 'Total duraiton of all sql queries'
      field :sql_queries, Graph::Connections::SqlQueries, null: true, description: 'Associated SQL Queries'

      timestamps(self)
    end
  end
end

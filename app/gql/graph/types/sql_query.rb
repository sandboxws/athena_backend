# frozen_string_literal: true
module Graph
  module Types
    class SqlQuery < Types::BaseObject
      description 'SQL Query Log'
      field :id, ID, null: false, description: 'Log primary key'
      field :table_name, String, null: false, description: 'Table name'
      field :schema_name, String, null: false, description: 'Schema name'
      field :query, String, null: false, description: 'The operation performed'
      field :query_excerpt, String, null: false, description: 'An excerpt of the query performed'
      field :operation, String, null: false, description: 'The operation performed'
      field :app_name, String, null: false, description: 'The originating app'
      field :source_name, String, null: false, description: 'Source of the query (ex: console, sidekiq, server, …)'
      field :duration, Float, null: false, description: 'Query duration in seconds'
      field :sidekiq_args, String, null: true, description: 'Sidekiq job args'
      field :session_id, String, null: false, description: 'A unique id identifying a session during which queries are logged.'
      field :stacktrace, Graph::Types::Stacktrace, null: false, description: 'Associated Stacktrace'
      field :sql_explain, Graph::Types::SqlExplain, null: true, description: 'Associated Query Explain'
      field :controller, Graph::Types::AwesomeController, null: true, description: 'Associated Controller'
      field :sidekiq_worker, Graph::Types::SidekiqWorker, null: true, description: 'Associated Sidekiq Job'

      timestamps(self)

      def query
        object.query_with_binds
      end
    end
  end
end

# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class Log < Types::BaseObject
        description 'MongoDB Query Log'
        field :id, ID, null: false, description: 'Log primary key'
        field :collection, String, null: false, description: 'Collection name'
        field :source_name, String, null: false, description: 'Query originating source'
        field :operation, String, null: false, description: 'The operation performed'
        field :app_name, String, null: true, description: 'The originating app'
        field :source_name, String, null: false, description: 'Source of the query (ex: console, sidekiq, server, …)'
        field :collscan, Boolean, null: true, description: 'A COLLSCAN flag'
        field :command, String, null: false, description: 'The command performed'
        field :command_excerpt, String, null: false, description: 'An excerpt of the command performed'
        field :duration, Float, null: false, description: 'Query duration in seconds'
        field :sidekiq_args, String, null: true, description: 'Sidekiq job args'
        field :session_id, String, null: false, description: 'A unique id identifying a session during which queries are logged.'
        field :lsid, String, null: false, description: 'Unique id generated by MonoDB server'
        field :stacktrace, Graph::Types::Mongodb::Stacktrace, null: false, description: 'Associated Stacktrace'
        field :explain, Graph::Types::Mongodb::Explain, null: true, description: 'Associated Query Explain'
        field :controller, Graph::Types::Mongodb::Controller, null: true, description: 'Associated Controller'
        field :sidekiq_worker, Graph::Types::SidekiqWorker, null: true, description: 'Associated Sidekiq Job'

        timestamps(self)
      end
    end
  end
end

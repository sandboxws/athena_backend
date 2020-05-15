# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class Controller < Types::BaseObject
        description 'MongoDB Query Controller'

        field :id, ID, null: false, description: 'Log primary key'
        field :name, String, null: false, description: 'Name of a rails controller'
        field :action, String, null: false, description: 'Rails controller action'
        field :path, String, null: false, description: 'Rails controller path'
        field :params, String, null: false, description: 'HTTP request params'
        field :params_excerpt, String, null: false, description: 'Mini version of the HTTP request params'
        field :session_id, String, null: false, description: 'A unique id identifying a session during which queries are logged.'
        field :ops_stats, [Stat], null: false, description: 'Controller stats'
        field :collections_stats, [CollectionStats], null: false, description: 'Controller stats'
        field :logs_count, Integer, null: false, description: 'Total count of logs per action per path'
        field :total_duration, Float, null: false, description: 'Total duraiton of all logs'
        field :collscans, Integer, null: false, description: 'Count of COLLSCAN queries'
        field :logs, Graph::Connections::Mongodb::Logs, null: false, description: 'Associated MongoDB Logs'

        timestamps(self)
      end
    end
  end
end

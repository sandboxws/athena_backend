# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class Dashboard < Types::BaseObject
        description 'MongoDB Dashboard'
        field :operations_stats, [Command], null: false, description: 'MongoDB commands stats'
        field :top_collections, [Command], null: false, description: 'MongoDB commands stats'

        field :mongodb_latest_logs, [Graph::Types::Mongodb::Log], null: false do
          argument :limit, Integer, default_value: 25, required: false
        end

        field :mongodb_latest_controllers, [Graph::Types::Mongodb::Controller], null: true do
          argument :limit, Integer, default_value: 25, required: false
        end

        def mongodb_latest_logs(**args)
          ::Mongodb::Log
            .where('controller_id is not null')
            .order('created_at desc')
            .limit(args.dig(:limit))
        end

        def mongodb_latest_controllers(**args)
          ::Mongodb::Controller
            .joins(:logs)
            .select('controllers.id, controllers.name, controllers.action, controllers.path, count(logs.id) as logs_count')
            .group('controllers.id, controllers.name, controllers.action, controllers.path')
            .order('controllers.id desc')
            .limit(args.dig(:limit))
        end
      end
    end
  end
end

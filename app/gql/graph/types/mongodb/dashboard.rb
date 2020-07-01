# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class Dashboard < Types::BaseObject
        description 'MongoDB Dashboard'
        field :operations_stats, [Command], null: false, description: 'MongoDB commands stats'
        field :top_collections, [Command], null: false, description: 'MongoDB commands stats'

        field :mongodb_latest_logs, [Graph::Types::Mongodb::Log], null: false do
          argument :limit, Integer, default_value: 10, required: false
        end

        field :mongodb_latest_controllers, [Graph::Types::Controller], null: true do
          argument :limit, Integer, default_value: 10, required: false
        end

        field :latest_sidekiq_workers, [Graph::Types::SidekiqWorker], null: true do
          argument :limit, Integer, default_value: 10, required: false
        end

        def mongodb_latest_logs(**args)
          ::Mongodb::Log
            .order('created_at desc')
            .limit(args.dig(:limit))
        end

        def mongodb_latest_controllers(**args)
          ::Controller
            .joins(:logs)
            .select('controllers.id, controllers.name, controllers.action, controllers.path, controllers.created_at, count(logs.id) as logs_count')
            .group('controllers.id, controllers.name, controllers.action, controllers.path, controllers.created_at')
            .order('controllers.id desc')
            .limit(args.dig(:limit))
        end

        def latest_sidekiq_workers(**args)
          ::SidekiqWorker
            .joins(:logs)
            .select('sidekiq_workers.id, sidekiq_workers.queue, sidekiq_workers.jid, sidekiq_workers.worker, sidekiq_workers.created_at, count(logs.id) as logs_count, round(sum(logs.duration), 5) as total_duration')
            .group('sidekiq_workers.id, sidekiq_workers.queue, sidekiq_workers.jid, sidekiq_workers.worker, sidekiq_workers.created_at')
            .order('sidekiq_workers.id desc')
            .limit(args.dig(:limit))
        end
      end
    end
  end
end

# frozen_string_literal: true
module Graph
  module Types
    class SidekiqWorker < Types::BaseObject
      description 'Sidekiq Job'

      field :id, ID, null: false, description: 'Sidekiq Job primary key'
      field :worker, String, null: false, description: 'Sidekiq worker class'
      field :queue, String, null: false, description: 'Sidekiq worker queue'
      field :jid, String, null: false, description: 'Sidekiq worker jid'
      field :params, String, null: false, description: 'Sidekiq worker params'
      field :params_excerpt, String, null: false, description: 'Sidekiq worker params'
      field :logs_count, Integer, null: false, description: 'Total count of logs originating from this sidekiq worker'
      field :total_duration, Float, null: false, description: 'Total duration for a queries originating from this sidekiq worker'
      field :ops_stats, [Stat], null: false, description: 'Operations stats'
      field :collections_stats, [CollectionStats], null: false, description: 'Collections stats'
      field :min_duration, Float, null: false, description: 'Min duration for a queries originating from this sidekiq worker'
      field :max_duration, Float, null: false, description: 'Max duration for a queries originating from this sidekiq worker'
      field :avg_duration, Float, null: false, description: 'Average duration for a queries originating from this sidekiq worker'

      timestamps(self)
    end
  end
end

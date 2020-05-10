Graph::Connections::Mongodb::Logs
# frozen_string_literal: true
module Graph
  module Types
    class SidekiqWorkersWithStats < Types::BaseObject
      description 'Sidekiq Workers with Stats'
      field :workers, [String], null: false, description: 'Sidekiq workers list'
      field :queues, [String], null: false, description: 'Sidekiq queues list'
      field :workers_stats, [Stat], null: false, description: 'Sidekiq workers stats'
      field :queues_stats, [Stat], null: false, description: 'Sidekiq queues stats'
      field :sidekiq_workers, Graph::Connections::SidekiqWorkers, null: false
    end
  end
end

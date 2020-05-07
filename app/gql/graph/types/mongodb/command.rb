# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class Command < Types::BaseObject
        description 'MongoDB Command'
        field :name, String, null: false, description: 'MongoDB command name'
        field :totalCount, Integer, null: false, description: 'MongoDB command total count'
        field :maxDuration, Float, null: false, description: 'MongoDB command max execution duration'
        # field :histogram, CommandHistogram, null: true, description: 'MongoDB command name'
      end
    end
  end
end

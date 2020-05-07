# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class GlobalStats < Types::BaseObject
        description 'MongoDB Query GlobalStats'

        field :collections, [String], null: false, description: 'List of queries collections'
        field :operations, [String], null: false, description: 'List of MongoDB operations'
      end
    end
  end
end

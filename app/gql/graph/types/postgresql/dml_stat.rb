# frozen_string_literal: true
module Graph
  module Types
    module Postgresql
      class DmlStat < Types::BaseObject
        description 'PostgreSQL DML Stat'
        field :id, ID, null: false, description: 'Primary key'
        field :schema_name, String, null: false, description: 'Schema name'
        field :table_name, String, null: false, description: 'Table name'
        field :total_inserts, Integer, null: false, description: 'Total Inserts'
        field :total_updates, Integer, null: false, description: 'Total Updates'
        field :total_deletes, Integer, null: false, description: 'Total Deletes'

        timestamps(self)
      end
    end
  end
end

# frozen_string_literal: true
module Graph
  module Types
    module Postgresql
      class SeqScan < Types::BaseObject
        description 'PostgreSQL Seq Scans'
        field :id, ID, null: false, description: 'Primary key'
        field :schema_name, String, null: false, description: 'Schema name'
        field :table_name, String, null: false, description: 'Table name'
        field :size_bytes, Integer, null: false, description: 'Table size in bytes'
        field :seq_scans, Integer, null: false, description: 'Seq scans'
        field :seq_tuple_reads, Integer, null: false, description: 'Seq Tuple Reads'
        field :index_scans, Integer, null: false, description: 'Index Scans'
        field :index_tuple_fetch, Integer, null: false, description: 'Index Tuple Fetch'

        timestamps(self)

        def seq_scans
          object.seq_scan
        end

        def seq_tuple_reads
          object.seq_tup_read
        end

        def index_scans
          object.idx_scan
        end

        def index_tuple_fetch
          object.idx_tup_fetch
        end
      end
    end
  end
end

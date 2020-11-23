# frozen_string_literal: true
module Graph
  module Types
    class SqlExplain < Types::BaseObject
      description 'SQL Query Explain'

      field :id, ID, null: false, description: 'SQL Query primary key'
      field :explain_output, String, null: false, description: 'The query performed'
      field :session_id, String, null: false, description: 'A unique id identifying a session during which queries are logged.'
      field :sql_query, Graph::Types::SqlQuery, null: false, description: 'SQL Query log'
      field :treeviz, String, null: true, description: "SQL's explain as JSON"
      field :startup_cost, Float, null: false, description: 'Total Startup Cost'
      field :total_cost, Float, null: false, description: 'Total Cost'
      field :rows, Float, null: false, description: 'Total Rows'
      field :width, Float, null: false, description: 'Total width'
      field :actual_startup_time, Float, null: false, description: 'Total actual startup time'
      field :actual_total_time, Float, null: false, description: 'Total actual total time'
      field :actual_rows, Float, null: false, description: 'Total actual rows'
      field :actual_loops, Float, null: false, description: 'Total actual loops'
      field :seq_scans, Integer, null: false, description: 'Seq Scans performed under any plan'
      field :stacktrace, Graph::Types::Stacktrace, null: false, description: 'Rails Stacktrace'
      field :controller, Graph::Types::Controller, null: true, description: 'Rails controller'

      timestamps(self)

      def startup_cost
        object.tree.startup_cost
      end

      def total_cost
        object.tree.total_cost.round(2)
      end

      def rows
        object.tree.rows
      end

      def width
        object.tree.width
      end

      def actual_startup_time
        object.tree.actual_startup_time.round(2)
      end

      def actual_total_time
        object.tree.actual_total_time.round(2)
      end

      def actual_rows
        object.tree.actual_rows
      end

      def actual_loops
        object.tree.actual_loops
      end

      def seq_scans
        object.tree.seq_scans
      end
    end
  end
end

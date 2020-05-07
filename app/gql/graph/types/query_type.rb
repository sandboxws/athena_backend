module Graph
  module Types
    class QueryType < Graph::Types::BaseObject
      field :dashboard, Graph::Types::Mongodb::Dashboard, null: false

      field :mongodb_logs, Graph::Connections::Mongodb::Logs, null: false do
        argument :limit, Integer, required: false, default_value: 25
        argument :page, Integer, required: false, default_value: 1
        argument :collections, [String], required: false, default_value: nil
        argument :operations, [String], required: false, default_value: nil
        argument :mode, String, required: false, default_value: 'latest'
      end

      field :logs_with_stats, Graph::Types::Mongodb::LogsWithStats, null: false do
        argument :limit, Integer, default_value: 25, required: false
        argument :page, Integer, default_value: 1, required: false
        argument :collections, [String], default_value: nil, required: false
        argument :operations, [String], default_value: nil, required: false
        argument :mode, String, required: false, default_value: 'latest'
      end

      field :mongodb_log, Graph::Types::Mongodb::Log, null: false do
        argument :id, Integer, required: true
      end

      field :mongodb_stacktraces, Graph::Connections::Mongodb::Stacktraces, null: false do
        argument :limit, Integer, default_value: 25, required: false
        argument :page, Integer, required: false, default_value: 1
      end

      field :mongodb_stacktrace, Graph::Types::Mongodb::Stacktrace, null: false do
        argument :id, Integer, required: true
      end

      field :mongodb_controllers, Graph::Connections::Mongodb::Controllers, null: false do
        argument :limit, Integer, default_value: 25, required: false
        argument :page, Integer, required: false, default_value: 1
        argument :names, [String], default_value: nil, required: false
        argument :mode, String, required: false, default_value: 'aggregate'
      end

      field :mongodb_controller, Graph::Types::Mongodb::Controller, null: false do
        argument :id, Integer, required: true
        argument :logs_page, Integer, required: false, default_value: 1
      end

      field :mongodb_explains, [Graph::Types::Mongodb::Explain], null: false, extras: [:ast_node] do
        argument :limit, Integer, default_value: 20, required: false
      end

      field :global_stats, Graph::Types::Mongodb::GlobalStats, null: false do
        argument :collections, [String], default_value: nil, required: false
        argument :operations, [String], default_value: nil, required: false
      end

      def dashboard
        ::DashboardService.stats
      end

      def mongodb_logs(**args)
        Queries::Logs.query do |q|
          q.collections = args.dig(:collections)
          q.operations = args.dig(:operations)
          q.limit = args.dig(:limit)
          q.page = args.dig(:page)
          q.mode = args.dig(:mode)
        end.mode_query
      end

      def mongodb_stacktraces(**args)
        relation = ::Mongodb::Stacktrace

        selections = args[:ast_node].selections
        selections_names = selections.map {|s| s.name}
        relation = relation.joins(:logs).includes(:logs).group('logs.collection') if selections_names.include?('logs')
        relation = relation.order('stacktraces.created_at desc').limit(args.dig(:limit))
        relation
      end

      def mongodb_controllers(**args)
        Queries::Controllers.query do |q|
          q.names = args.dig(:names)
          q.limit = args.dig(:limit)
          q.page = args.dig(:page)
          q.mode = args.dig(:mode)
        end.mode_query
      end

      def mongodb_stacktraces(**args)
        Queries::Stacktraces.query do |q|
          q.names = args.dig(:names)
          q.limit = args.dig(:limit)
          q.mode = :aggregate
        end.mode_query
      end

      def mongodb_explains(**args)
        relation = ::Mongodb::Explain
        relation.order('created_at desc').limit(args.dig(:limit))
      end

      def logs_with_stats(**args)
        logs = Queries::Logs.query do |q|
          q.collections = args.dig(:collections)
          q.operations = args.dig(:operations)
          q.limit = args.dig(:limit)
          q.page = args.dig(:page)
          q.mode = :latest
        end
        OpenStruct.new({
          collections: logs.collections_list,
          operations: logs.operations_list,
          collections_stats: logs.collections_stats,
          operations_stats: logs.operations_stats,
          logs: logs.mode_query
        })
      end

      def global_stats(**args)
        puts args.inspect
        relation = ::Mongodb::Log
        relation = relation.where('collection in (?)', args.dig(:collections)) if args.dig(:collections).present?
        collections = relation.distinct('collection').pluck('collection')

        relation = ::Mongodb::Log
        relation = relation.where('operation in (?)', args.dig(:operations)) if args.dig(:operations).present?
        operations = relation.distinct('operation').pluck('operation')
        OpenStruct.new({
          collections: collections,
          operations: operations
        })
      end

      def mongodb_log(**args)
        ::Mongodb::Log.find(args.dig(:id))
      end

      def mongodb_stacktrace(**args)
        stacktrace = ::Mongodb::Stacktrace.find(args.dig(:id))
        logs = stacktrace.logs.page(args.dig(:logs_page)).per(10)
        logs_count = stacktrace.logs.count
        stats = stacktrace
          .logs
          .select('stacktrace_id, min(logs.duration) as min_duration, max(logs.duration) as max_duration, avg(logs.duration) as avg_duration')
          .group('stacktrace_id').first
        OpenStruct.new({
          id: stacktrace.id,
          stacktrace: stacktrace.stacktrace,
          stacktrace_excerpt: stacktrace.stacktrace_excerpt,
          logs_count: logs_count,
          min_duration: stats.min_duration,
          max_duration: stats.max_duration,
          avg_duration: stats.avg_duration,
          logs: logs,
          created_at: stacktrace.created_at,
          updated_at: stacktrace.updated_at,
        })
      end

      def mongodb_controller(**args)
        controller = ::Mongodb::Controller.find(args.dig(:id))
        logs = controller.logs.page(args.dig(:logs_page)).per(10)
        logs_count = controller.logs.count
        stats = controller
          .logs
          .select('collection, operation, count(*) logs_count')
          .order('count(logs.id) desc')
          .group('collection, operation')
        ops_stats = stats.inject(Hash.new(0)) do |h, l|
          h[l.operation] += l.logs_count; h
        end.map {|name, value| OpenStruct.new({
          name: name,
          value: value
        })}
        stats = stats.group_by do |l|
          l.collection
        end.map {|name, stats| OpenStruct.new({
          name: name,
          stats: stats.map {|stat| OpenStruct.new({name: stat.operation, value: stat.logs_count})}
        })}
        collscans = controller.explains.where('collscan = 1').count
        total_duration = logs.sum(:duration)
        OpenStruct.new({
          id: controller.id,
          name: controller.name,
          action: controller.action,
          path: controller.path,
          params: controller.params,
          logs_count: logs_count,
          session_id: controller.session_id,
          total_duration: total_duration,
          ops_stats: ops_stats,
          collections_stats: stats,
          collscans: collscans,
          logs: logs,
          created_at: controller.created_at,
          updated_at: controller.updated_at,
        })
      end
    end
  end
end

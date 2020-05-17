module Graph
  module Types
    class QueryType < Graph::Types::BaseObject
      field :dashboard, Graph::Types::Mongodb::Dashboard, null: false

      field :mongodb_logs, Graph::Connections::Mongodb::Logs, null: false do
        argument :controller_id, Integer, required: false
        argument :stacktrace_id, Integer, required: false
        argument :limit, Integer, required: false, default_value: 25
        argument :page, Integer, required: false, default_value: 1
        argument :collections, [String], required: false, default_value: nil
        argument :operations, [String], required: false, default_value: nil
        argument :source_names, [String], default_value: nil, required: false
        argument :mode, String, required: false, default_value: 'latest'
      end

      field :logs_with_stats, Graph::Types::Mongodb::LogsWithStats, null: false do
        argument :controller_id, Integer, required: false
        argument :stacktrace_id, Integer, required: false
        argument :sidekiq_worker_id, Integer, required: false
        argument :limit, Integer, default_value: 25, required: false
        argument :page, Integer, default_value: 1, required: false
        argument :collections, [String], default_value: nil, required: false
        argument :operations, [String], default_value: nil, required: false
        argument :source_names, [String], default_value: nil, required: false
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
        argument :logs_page, Integer, required: false, default_value: 1
      end

      field :sidekiq_workers_with_stats, Graph::Types::SidekiqWorkersWithStats, null: false do
        argument :limit, Integer, default_value: 25, required: false
        argument :page, Integer, default_value: 1, required: false
        argument :workers, [String], default_value: nil, required: false
        argument :queues, [String], default_value: nil, required: false
        argument :mode, String, required: false, default_value: 'latest'
      end

      field :sidekiq_worker, Graph::Types::SidekiqWorker, null: false do
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
          q.controller_id = args.dig(:controller_id)
          q.stacktrace_id = args.dig(:stacktrace_id)
          q.collections = args.dig(:collections)
          q.operations = args.dig(:operations)
          q.source_names = args.dig(:source_names)
          q.limit = args.dig(:limit)
          q.page = args.dig(:page)
          q.mode = :latest
        end.mode_query
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
          q.page = args.dig(:page)
          q.limit = args.dig(:limit)
          q.mode = :aggregate
        end.mode_query
      end

      def sidekiq_workers_with_stats(**args)
        queries_count = ::Mongodb::Log.where('sidekiq_worker_id is not null').count
        total_duration = ::Mongodb::Log.where('sidekiq_worker_id is not null').sum('duration').round(2)
        sidekiq_workers = Queries::SidekiqWorkers.query do |q|
          q.workers = args.dig(:workers)
          q.queues = args.dig(:queues)
          q.limit = args.dig(:limit)
          q.page = args.dig(:page)
          q.mode = args.dig(:mode)
        end
        OpenStruct.new({
          queries_count: queries_count,
          total_duration: total_duration,
          workers: sidekiq_workers.workers_list,
          queues: sidekiq_workers.queues_list,
          workers_stats: sidekiq_workers.workers_stats,
          queues_stats: sidekiq_workers.queues_stats,
          sidekiq_workers: sidekiq_workers.mode_query
        })
      end

      def mongodb_explains(**args)
        relation = ::Mongodb::Explain
        relation.order('created_at desc').limit(args.dig(:limit))
      end

      def logs_with_stats(**args)
        total_duration = ::Mongodb::Log.sum(:duration).round(5)
        logs = Queries::Logs.query do |q|
          q.controller_id = args.dig(:controller_id)
          q.stacktrace_id = args.dig(:stacktrace_id)
          q.sidekiq_worker_id = args.dig(:sidekiq_worker_id)
          q.collections = args.dig(:collections)
          q.operations = args.dig(:operations)
          q.source_names = args.dig(:source_names)
          q.limit = args.dig(:limit)
          q.page = args.dig(:page)
          q.mode = :latest
        end
        OpenStruct.new({
          total_duration: total_duration,
          collections: logs.collections_list,
          operations: logs.operations_list,
          source_names: logs.source_names_list,
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
        sources_stats = stacktrace.logs
          .select('source_name, count(*) as queries')
          .group('source_name')
          .to_a.map {|r| OpenStruct.new(name: r[:source_name], value: r[:queries])}
        stats = stacktrace
          .logs
          .select('stacktrace_id, round(min(logs.duration), 5) as min_duration, round(max(logs.duration), 2) as max_duration, round(avg(logs.duration), 5) as avg_duration')
          .group('stacktrace_id').first
        OpenStruct.new({
          id: stacktrace.id,
          stacktrace: stacktrace.stacktrace,
          stacktrace_excerpt: stacktrace.stacktrace_excerpt,
          logs_count: logs_count,
          min_duration: stats.min_duration,
          max_duration: stats.max_duration,
          avg_duration: stats.avg_duration,
          sources_stats: sources_stats,
          logs: logs,
          created_at: stacktrace.created_at,
          updated_at: stacktrace.updated_at,
        })
      end

      def sidekiq_worker(**args)
        sidekiq_worker = ::SidekiqWorker.find(args.dig(:id))
        logs = sidekiq_worker.logs.page(args.dig(:logs_page)).per(10)
        logs_count = sidekiq_worker.logs.count

        logs_stats = sidekiq_worker
          .logs
          .select('sidekiq_worker_id, round(sum(logs.duration), 5) as total_duration, round(min(logs.duration), 5) as min_duration, round(max(logs.duration), 5) as max_duration, round(avg(logs.duration), 5) as avg_duration')
          .group('sidekiq_worker_id').first

        stats = sidekiq_worker
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
        OpenStruct.new({
          id: sidekiq_worker.id,
          worker: sidekiq_worker.worker,
          queue: sidekiq_worker.queue,
          jid: sidekiq_worker.jid,
          params: sidekiq_worker.params,
          params_excerpt: sidekiq_worker.params_excerpt,
          logs_count: logs_count,
          total_duration: logs_stats.total_duration,
          ops_stats: ops_stats,
          collections_stats: stats,
          min_duration: logs_stats.min_duration,
          max_duration: logs_stats.max_duration,
          avg_duration: logs_stats.avg_duration,
          logs: logs,
          created_at: sidekiq_worker.created_at,
          updated_at: sidekiq_worker.updated_at,
        })
      end

      def mongodb_controller(**args)
        controller = ::Mongodb::Controller.find(args.dig(:id))
        logs = controller.logs.page(args.dig(:logs_page)).per(2)
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
        total_duration = controller.logs.sum(:duration)
        OpenStruct.new({
          id: controller.id,
          name: controller.name,
          action: controller.action,
          path: controller.path,
          params: controller.params,
          params_excerpt: controller.params_excerpt,
          logs_count: logs_count,
          session_id: controller.session_id,
          total_duration: total_duration.round(5),
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

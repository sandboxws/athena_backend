class DashboardService
  def self.stats
    commands = [
      :find,
      :insert,
      :update,
      :distinct,
      :delete,
      :aggregate,
      :count,
      :getMore
    ]
    operation_stats_default = commands.inject({}) {|h, k| h[k] = { count: 0, max_duration: 0 }; h}.with_indifferent_access
      operations_stats = operation_stats_default.merge(
        ::Mongodb::Log
          .select('operation, count(operation) as count, max(duration) as max_duration')
          .group('operation')
          .inject({}) {|h, l| h[l.operation.to_sym] = { count: l.count, max_duration: l.max_duration }; h}
      )

      # @logs = Log.order('created_at desc').limit(5)
      # @slowest_logs = Log.order('duration desc').limit(10)
      # @stacktraces = Stacktrace.order('created_at desc').limit(5)
      # @slowest_stacktraces = Stacktrace.where('id in (?)', @slowest_logs.pluck(:stacktrace_id).uniq).limit(10)

      top_collections = ::Mongodb::Log.select("id, collection, max(duration) max_duration, count(*) total_count").group('collection').order('count(*) desc').limit(10)

      OpenStruct.new(
        operations_stats: commands.map do |cmd|
          {
            name: cmd,
            total_count: operations_stats.dig(cmd, :count),
            max_duration: operations_stats.dig(cmd, :max_duration)
          }
        end,
        top_collections: top_collections.map do |log|
          {
            name: log.collection,
            total_count: log.total_count,
            max_duration: log.max_duration
          }
        end
      )
  end
end

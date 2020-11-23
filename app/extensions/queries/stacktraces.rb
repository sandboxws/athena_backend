module Queries
  class Stacktraces
    attr_accessor :relation,
      :names,
      :duration,
      :page,
      :limit,
      :mode

    def self.query(&block)
      instance = Queries::Stacktraces.new
      instance.instance_eval(&block)
      instance.build_query
      instance
    end

    def init_query
      @relation = ::Stacktrace.where('stacktrace <> "[]"')
      self
    end

    def to_sql
      @relation.to_sql
    end

    def build_query
      init_query
        .relation
    end

    def aggregates_relation
      # @relation = @relation.joins(:logs)
      #   .select('stacktraces.id, stacktraces.stacktrace, count(logs.id) as logs_count, round(min(logs.duration), 5) as min_duration, round(max(logs.duration), 5) as max_duration, round(avg(logs.duration), 5) as avg_duration')
      #   .group('stacktraces.id, stacktraces.stacktrace')
      @relation = @relation.left_outer_joins(:logs)
        .select('stacktraces.id, stacktraces.stacktrace, count(logs.id) as logs_count, round(min(logs.duration), 5) as min_duration, round(max(logs.duration), 5) as max_duration, round(avg(logs.duration), 5) as avg_duration')
        .group('stacktraces.id, stacktraces.stacktrace')

      @relation = @relation.left_outer_joins(:sql_queries)
        .select('stacktraces.id, stacktraces.stacktrace, count(sql_queries.id) as sql_queries_count, round(min(sql_queries.duration), 5) as sql_queries_min_duration, round(max(sql_queries.duration), 5) as sql_queries_max_duration, round(avg(sql_queries.duration), 5) as sql_queries_avg_duration')
        .group('stacktraces.id, stacktraces.stacktrace')
      self
    end

    def order_relation
      @relation = @relation.order('stacktraces.id desc')
      self
    end

    def limit_relation
      @relation = @relation.limit(limit) if limit.present?
      self
    end

    def page_relation
      @relation = @relation.page(page) if page.present?
      self
    end

    def query
      @relation
    end

    def mode_query
      self.send "#{mode}_mode"
    end

    def aggregate_mode
      aggregates_relation
        .relation
        .order('stacktraces.created_at desc')
        .page(page)
        .per(limit)
    end

    def latest_mode
      @relation
        .order('created_at desc')
        .page(page)
        .per(limit)
    end
  end
end

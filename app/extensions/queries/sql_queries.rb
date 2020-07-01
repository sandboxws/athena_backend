module Queries
  class SqlQueries
    attr_accessor :relation,
      :controller_id,
      :stacktrace_id,
      :sidekiq_worker_id,
      :tables,
      :operations,
      :source_names,
      :duration,
      :page,
      :limit,
      :mode

    def self.query(&block)
      instance = Queries::SqlQueries.new
      instance.instance_eval(&block)
      instance.build_query
      instance
    end

    def init_query
      @relation = ::SqlQuery
      self
    end

    def to_sql
      @relation.to_sql
    end

    def build_query
      init_query
        .controller_id_relation
        .stacktrace_id_relation
        .sidekiq_worker_id_relation
        .tables_relation
        .operations_relation
        .source_names_relation
        .relation
        # .mode_relation
    end

    def controller_id_relation
      @relation = @relation.where('controller_id = ?', controller_id) if controller_id.present?
      self
    end

    def stacktrace_id_relation
      @relation = @relation.where('stacktrace_id = ?', stacktrace_id) if stacktrace_id.present?
      self
    end

    def sidekiq_worker_id_relation
      @relation = @relation.where('sidekiq_worker_id = ?', sidekiq_worker_id) if sidekiq_worker_id.present?
      self
    end

    def tables_relation
      @relation = @relation.where('table_name in (?)', tables) if tables.present?
      self
    end

    def operations_relation
      @relation = @relation.where('operation in (?)', operations) if operations.present?
      self
    end

    def source_names_relation
      @relation = @relation.where('source_name in (?)', source_names) if source_names.present?
      self
    end

    def mode_relation
      self.send "#{mode}_mode" if mode.present?
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

    def operations_stats
      @relation.group('operation').count.map do |key, value|
        OpenStruct.new({
          name: key,
          value: value
        })
      end
    end

    def tables_stats
      @relation.group('table_name').count.map do |key, value|
        OpenStruct.new({
          name: key,
          value: value
        })
      end
    end

    def tables_list
      @relation.distinct('table_name').pluck(:table_name).sort
    end

    def operations_list
      @relation.distinct('operation').pluck(:operation)
    end

    def source_names_list
      @relation.distinct('source_name').pluck(:source_name)
    end

    def query
      @relation
    end

    def mode_query
      self.send "#{mode}_mode"
    end

    def latest_mode
      @relation
        .order('created_at desc')
        .page(page)
        .per(limit)
    end
  end
end

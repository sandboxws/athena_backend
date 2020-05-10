module Queries
  class SidekiqWorkers
    attr_accessor :relation,
      :workers,
      :queues,
      :duration,
      :page,
      :limit,
      :mode

    def self.query(&block)
      instance = Queries::SidekiqWorkers.new
      instance.instance_eval(&block)
      instance.build_query
      instance
    end

    def init_query
      @relation = ::SidekiqWorker
      self
    end

    def to_sql
      @relation.to_sql
    end

    def build_query
      init_query
        .workers_relation
        .queues_relation
        .relation
    end

    def aggregates_relation
      @relation = @relation.joins(:logs)
        .select('sidekiq_workers.id, sidekiq_workers.worker, sidekiq_workers.queue, sidekiq_workers.jid, sidekiq_workers.params, count(logs.id) as logs_count, round(min(logs.duration), 5) as min_duration, round(max(logs.duration), 5) as max_duration, round(avg(logs.duration), 5) as avg_duration')
        .group('sidekiq_workers.id, sidekiq_workers.worker, sidekiq_workers.queue, sidekiq_workers.jid, sidekiq_workers.params')
      self
    end

    def workers_relation
      @relation = @relation.where('worker in (?)', workers) if workers.present?
      self
    end

    def queues_relation
      @relation = @relation.where('queue in (?)', queues) if queues.present?
      self
    end

    def order_relation
      @relation = @relation.order('sidekiq_workers.id desc')
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

    def latest_mode
      @relation
        .order('created_at desc')
        .page(page)
        .per(limit)
    end

    def aggregate_mode
      aggregates_relation
        .relation
        .order('sidekiq_workers.created_at desc')
        .page(page)
        .per(limit)
    end

    def workers_stats
      @relation.group('worker').count.map do |key, value|
        OpenStruct.new({
          name: key,
          value: value
        })
      end
    end

    def queues_stats
      @relation.group('queue').count.map do |key, value|
        OpenStruct.new({
          name: key,
          value: value
        })
      end
    end

    def queues_list
      @relation.distinct('queue').pluck(:queue)
    end

    def workers_list
      @relation.distinct('worker').pluck(:worker)
    end
  end
end

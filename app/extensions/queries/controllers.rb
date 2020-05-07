module Queries
  class Controllers
    attr_accessor :relation,
      :names,
      :duration,
      :page,
      :limit,
      :mode

    def self.query(&block)
      instance = Queries::Controllers.new
      instance.instance_eval(&block)
      instance.build_query
      instance
    end

    def init_query
      @relation = ::Mongodb::Controller
      self
    end

    def to_sql
      @relation.to_sql
    end

    def build_query
      init_query
        .names_relation
        .relation
    end

    def names_relation
      @relation = @relation.where('name in (?)', names) if names.present?
      self
    end

    def aggregates_relation
      @relation = @relation.joins(:logs)
        .select('controllers.id, controllers.name, controllers.action, controllers.path, controllers.session_id, count(logs.id) as logs_count, sum(logs.duration) as total_duration')
        .group('controllers.id, controllers.name, controllers.action, controllers.path, controllers.session_id')
      self
    end

    def order_relation
      @relation = @relation.order('controllers.id desc')
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
        .order('controllers.created_at desc')
        .page(page)
        .per(limit)
    end
  end
end

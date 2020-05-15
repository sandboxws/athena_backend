module Queries
  class Logs
    attr_accessor :relation,
      :collections,
      :operations,
      :source_names,
      :duration,
      :page,
      :limit,
      :mode

    def self.query(&block)
      instance = Queries::Logs.new
      instance.instance_eval(&block)
      instance.build_query
      instance
    end

    def init_query
      @relation = ::Mongodb::Log
      self
    end

    def to_sql
      @relation.to_sql
    end

    def build_query
      init_query
        .collections_relation
        .operations_relation
        .source_names_relation
        .relation
        # .mode_relation
    end

    def collections_relation
      @relation = @relation.where('collection in (?)', collections) if collections.present?
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

    def collections_stats
      @relation.group('collection').count.map do |key, value|
        OpenStruct.new({
          name: key,
          value: value
        })
      end
    end

    def collections_list
      @relation.distinct('collection').pluck(:collection)
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

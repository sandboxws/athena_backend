class SqlQuery < ActiveRecord::Base
  belongs_to :stacktrace
  belongs_to :sql_explain
  belongs_to :controller, class_name: 'AwesomeController'
  belongs_to :sidekiq_worker

  def query_excerpt
    query&.truncate(140)
  end

  def query_with_binds
    q = query
    JSON.parse(binds).each_with_index { |v, idx| q = q.gsub(/\$#{idx + 1}/, v.to_json) }

    q
  end

  def duration
    self[:duration].round(5)
  end
end

class Stacktrace < ActiveRecord::Base
  has_many :logs, class_name: 'Mongodb::Log'
  has_many :sql_queries
  has_many :explains
  has_many :sql_explains

  def stacktrace
    JSON.parse self['stacktrace']
  end

  def stacktrace_excerpt
    stacktrace.first.truncate(140)
  end

  def logs_count
    ::Mongodb::Log.where(stacktrace_id: id).count
  end

  def sql_queries_count
    ::SqlQuery.where(stacktrace_id: id).count
  end
end

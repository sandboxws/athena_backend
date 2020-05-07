class Mongodb::Stacktrace < ActiveRecord::Base
  has_many :logs
  has_many :explains

  def stacktrace
    JSON.parse self['stacktrace']
  end

  def stacktrace_excerpt
    stacktrace.first.truncate(140)
  end
end

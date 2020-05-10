class SidekiqWorker < ActiveRecord::Base
  has_many :logs, class_name: 'Mongodb::Log'

  def params_excerpt
    params.truncate(190)
  end
end

class Mongodb::Log < ActiveRecord::Base
  belongs_to :stacktrace
  belongs_to :explain
  belongs_to :controller

  def command_excerpt
    command.truncate(140)
  end
end

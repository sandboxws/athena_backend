class Mongodb::Controller < ActiveRecord::Base
  has_many :logs
  has_many :explains

  def total_duration
    logs.sum(:duration).round(3)
  end

  def gql?
    path =~ /graphql/ || name =~ /GraphqlController/
  end

  def formatted_params
    h_params = JSON.parse(params)
    gql? ? h_params.dig('graphql') : h_params
  end

  def node
    self
  end

  def self.historical_stats(controller_name, controller_action)
    ::Mongodb::Controller
      .joins(:logs)
      .where('controllers.name = ? and controllers.action = ?', controller_name, controller_action)
      .select('controllers.id, controllers.name, controllers.action, count(logs.id) as logs_count, round(sum(logs.duration), 2) as total_duration')
      .group('controllers.id, controllers.name, controllers.action')
  end
end

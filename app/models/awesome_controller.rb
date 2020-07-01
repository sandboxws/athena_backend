class AwesomeController < ActiveRecord::Base
  self.table_name = 'controllers'
  has_many :logs, class_name: 'Mongodb::Log', foreign_key: :controller_id
  has_many :sql_queries, foreign_key: :controller_id
  has_many :explains, class_name: 'Mongodb::Explain', foreign_key: :controller_id
  has_many :sql_explains, foreign_key: :controller_id

  def params_excerpt
    params.truncate(190)
  end

  def sql_total_duration
    sql_queries.sum(:duration).round(3)
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

  def self.sql_historical_stats(controller_name, controller_action)
    AwesomeController
      .joins(:sql_queries)
      .where('controllers.name = ? and controllers.action = ?', controller_name, controller_action)
      .select('controllers.id, controllers.name, controllers.action, count(sql_queries.id) as sql_queries_count, round(sum(sql_queries.duration), 2) as total_duration')
      .group('controllers.id, controllers.name, controllers.action')
  end

  def total_duration
    logs.sum(:duration).round(5)
  end

  def sql_total_duration
    sql_queries.sum(:duration).round(5)
  end

  def logs_count
    logs.count
  end

  def sql_queries_count
    sql_queries.count
  end
end

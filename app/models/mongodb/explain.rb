class Mongodb::Explain < ActiveRecord::Base
  belongs_to :stacktrace
  belongs_to :controller
  has_one :log

  def to_s
    "collection: #{collection}, winning_plan: #{winning_plan}, duration: #{duration}, documents_returned: #{documents_returned}, documents_examined: #{documents_examined}"
  end

  def stages_count
    winning_plan_tree&.stages_count
  end

  def treeviz
    winning_plan_tree.treeviz.to_json
  end

  def winning_plan_tree
    @tree ||= ::Mongodb::PlanTree.build(JSON.parse(winning_plan_raw).with_indifferent_access)
  end
end

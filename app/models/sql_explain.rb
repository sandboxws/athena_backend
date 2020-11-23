class SqlExplain < ActiveRecord::Base
  belongs_to :stacktrace
  belongs_to :controller
  has_one :sql_query

  def treeviz
    tree.treeviz.to_json
  end

  def tree
    @tree ||= PlanTree.build(JSON.parse(explain_output))
  end

  def tree_root
    tree.root
  end
end

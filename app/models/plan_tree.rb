class PlanTree
  attr_accessor :root,
    :ids,
    :plans_count,
    :seq_scan,
    :seq_scans,
    :startup_cost,
    :total_cost,
    :rows,
    :width,
    :actual_startup_time,
    :actual_total_time,
    :actual_rows,
    :actual_loops

  alias :seq_scan? :seq_scan

  def initialize
    self.startup_cost = 0
    self.total_cost = 0
    self.rows = 0
    self.width = 0
    self.actual_startup_time = 0
    self.actual_total_time = 0
    self.actual_rows = 0
    self.actual_loops = 0
    self.seq_scans = 0
  end

  def self.build(plan)
    tree = PlanTree.new
    tree.ids = (2..500).to_a
    root = PlanNode.build(plan.first.dig('Plan'))
    tree.update_tree_stats(root)
    root.id = 1
    tree.plans_count = 1
    build_recursive(plan.first.dig('Plan', 'Plans'), root, tree)
    tree.root = root
    tree
  end

  def self.build_recursive(data, parent, tree)
    return unless data.present?

    if data.is_a?(Array)
      data.each do |plan|
        build_recursive(plan, parent, tree)
      end
    elsif data.is_a?(Hash) && data.dig('Plans').present?
      # puts data.dig('Node Type')
      node = PlanNode.build(data, parent)
      # tree.update_tree_stats(node)
      node.id = tree.ids.shift
      parent.children << node
      tree.plans_count += 1
      tree.seq_scans += 1 if node.seq_scan?
      build_recursive(data.dig('Plans'), node, tree)
    elsif data.is_a?(Hash) && data.dig('Plans').nil?
      # puts data.dig('Node Type')
      node = PlanNode.build(data, parent)
      tree.update_tree_stats(node)
      node.id = tree.ids.shift
      tree.plans_count += 1
      tree.seq_scans += 1 if node.seq_scan?
      parent.children << node
    end

    # puts '@@@@@@@@@'
    # puts data.inspect
    # puts '@@@@@@@@@'
    # if !data.is_a?(Array) && data.dig('Plans').present?
    #   # Parent doesn't change
    #   puts '>>>>>>'
    #   puts data.dig('Plans').inspect
    #   puts '>>>>>>'
    #   tree.plans_count += 1
    #   data.dig('Plans').each do |plan|
    #     node = PlanNode.build(plan, parent)
    #     node.id = tree.ids.shift
    #     parent.children << node
    #     # tree.collscan = 1 if node.collscan? && !tree.collscan
    #     build_recursive(plan, node, tree)
    #   end
    # elsif !data.is_a?(Array) && data.dig('Plan').present? && data.dig('Plan', 'Plans').present?
    #   # Parent changes
    #   node = PlanNode.build(data, parent)
    #   node.id = tree.ids.shift
    #   parent.children << node
    #   tree.plans_count += 1
    #   # tree.collscan = 1 if node.collscan? && !tree.collscan
    #   puts '============'
    #   puts data.dig('Plan', 'Plans').inspect
    #   puts '============'
    #   build_recursive(data.dig('Plans'), node, tree)
    # else
    #   # Parent doesn't change
    #   puts '**********'
    #   puts data.inspect
    #   puts '**********'
    #   node = PlanNode.build(data, parent)
    #   node.id = tree.ids.shift
    #   tree.plans_count += 1
    #   # tree.collscan = 1 if node.collscan? && !tree.collscan
    #   parent.children << node
    # end
  end

  # Breadth First Traversal
  def treeviz
    return unless root.present?
    output = []
    queue = [root]
    while(!queue.empty?) do
      node = queue.shift
      output << node.treeviz
      node.children.each do |child|
        queue << child
      end
    end

    output
  end

  def update_tree_stats(node)
    self.startup_cost += node.startup_cost
    self.total_cost += node.total_cost
    self.rows += node.rows
    self.width += node.width
    self.actual_startup_time += node.actual_startup_time
    self.actual_total_time += node.actual_total_time
    self.actual_rows += node.actual_rows
    self.actual_loops += node.actual_loops
  end
end

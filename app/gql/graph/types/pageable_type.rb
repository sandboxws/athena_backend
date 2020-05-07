module Graph
  module Types
    module PageableType
      include BaseInterface
      field :current_page, Integer, null: true
      field :previous_page, Integer, null: true, method: :prev_page
      field :next_page, Integer, null: true
      field :total_pages, Integer, null: true
      field :total_items, Integer, null: true, method: :total_count
      field :size, Integer, null: true, method: :count
      field :first_page, Boolean, null: true, method: :first_page?
      field :last_page, Boolean, null: true, method: :last_page?
    end
  end
end

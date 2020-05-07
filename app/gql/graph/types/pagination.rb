# frozen_string_literal: true
module Graph
  module Types
    module Mongodb
      class Pagination < Types::BaseObject
        description 'MongoDB Query Log'
        field :count, Integer, null: false, description: 'Total count of records'
        field :total_pages, Integer, null: false, description: 'Total number of pages'
        field :current_page, Integer, null: false, description: 'Current paginated page'
        field :next_page, Integer, null: false, description: 'Next paginated page'
        field :prev_page, Integer, null: false, description: 'Previous paginated page'
        field :first_page, Boolean, null: false, description: 'True if current page is the first page'
        field :last_page, Boolean, null: false, description: 'True if current page is the last page'
      end
    end
  end
end

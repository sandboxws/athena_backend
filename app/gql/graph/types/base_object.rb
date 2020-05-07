module Graph
  module Types
    class BaseObject < GraphQL::Schema::Object
      field_class Types::BaseField

      def self.timestamps(type)
        type.field :createdAt, Types::DateTime, method: :created_at, null: false, description: 'Timestamp in UTC'
        type.field :updatedAt, Types::DateTime, method: :updated_at, null: false, description: 'Timestamp in UTC'
      end
    end
  end
end

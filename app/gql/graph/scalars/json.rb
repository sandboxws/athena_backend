module Graph
  module Scalars
    class Json < Graph::Types::BaseScalar
      description "A raw all-or-nothing JSON object"

      def self.coerce_input(value, _ctx)
        begin
          if value.is_a? String
            JSON.parse value
          else
            value
          end
        rescue
          GraphQL::ExecutionError.new('Invalid JSON input')
        end
      end
      def self.coerce_result(value, _ctx)
        begin
          value&.as_json
        rescue
          GraphQL::ExecutionError.new('Cannot coerce value to JSON')
        end
      end
    end
  end
end

module Graph
  module Types
    class BaseInputObject < GraphQL::Schema::InputObject
      extend Forwardable
      def_delegators :@object, :node
      def_delegator :node, :id

      # A description which is inherited and may be overridden
      description "An edge in a connection."

      def self.inherited(child_class)
        # super was not called in the example code from the blog post, but it is required
        # to be called in an `inherited` method:
        super

        begin
          wrapped_type_name = child_class.name.split("::").last.sub("Edge", "")
          wrapped_type_class = Types.const_get(wrapped_type_name, false)
          # Add a default `node` field, assuming the object type name matches.
          # If it doesn't match, you can override this in subclasses
          child_class.field :node, wrapped_type_class,
            null: true, description: "The item at the end of the edge."
        rescue NameError
          # expect the :node field to be set up in the subclass
        end
      end

      # A cursor field which is inherited
      field :cursor, String,
        null: false,
        description: "A cursor for use in pagination."
    end
  end
end

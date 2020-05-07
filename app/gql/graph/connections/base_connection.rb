module Graph
  module Connections
    # class BaseConnection < Graph::Types::BaseObject
    class BaseConnection < GraphQL::Types::Relay::BaseConnection
      field :total_count, Integer, null: false
      def total_count
        object.nodes.size
      end
      # # For some reason these are needed, they call through to the underlying connection wrapper.
      # extend Forwardable
      # def_delegators :@object, :cursor_from_node, :parent

      # # When this class is extended, add the default connection behaviors.
      # # This adds a new `graphql_name` and description, and searches
      # # for a corresponding edge type.
      # # See `.edge_type` for how the fields are added.
      # def self.inherited(child_class)
      #   # super was not called in the example code from the blog post, but it is required
      #   # to be called in an `inherited` method:
      #   super

      #   # I simplified this section a bit because I didn't follow the same naming convention
      #   # as GitHub. I also converted all of my connections and edges in the same PR because
      #   # I couldn't get an incremental upgrade to work reliably. I'm on Ruby 2.5 so I also got
      #   # rid of the `require_dependency` calls, and this could probably be simplified even
      #   # further. YMMV!
      #   #
      #   # The child_class will be named like `Types::UserConnection`. Strip off the `Connection`
      #   # part of it and then look for `Types::UserEdge` for the edge class and `Types::User`
      #   # for the node class.
      #   type_name = child_class.name.split("::").last.sub("Connection", "")

      #   begin
      #     # Look for a custom edge whose name matches this connection's name
      #     wrapped_edge_class = Types.const_get("#{type_name}Edge", false)
      #     wrapped_node_class = wrapped_edge_class.fields["node"].type
      #   rescue NameError
      #     begin
      #       # If the custom edge file doesn't exist, look for an object
      #       wrapped_node_class = Types.const_get(type_name, false)
      #       wrapped_edge_class = wrapped_node_class.edge_type
      #     rescue NameError
      #       # Assume that `edge_type` will be called later
      #       wrapped_edge_class = wrapped_node_class = nil
      #     end
      #   end

      #   # If a default could be found using constant lookups, generate the fields for it.
      #   if wrapped_edge_class
      #     if wrapped_edge_class.is_a?(GraphQL::ObjectType) || (
      #       wrapped_edge_class.is_a?(Class) && wrapped_edge_class < Types::BaseEdge
      #     )
      #       child_class.edge_type(wrapped_edge_class, node_type: wrapped_node_class)
      #     else
      #       raise TypeError,
      #         "Missed edge type lookup, didn't find a type definition: #{type_name.inspect} "\
      #         "=> #{wrapped_edge_class.inspect}"
      #     end
      #   end
      # end

      # # Configure this connection to return `edges` and `nodes` based on `edge_type_class`.
      # #
      # # This method will use the inputs to create:
      # # - `edges` field
      # # - `nodes` field
      # # - description
      # #
      # # It's called when you subclass this base connection, trying to use the
      # # class name to set defaults. You can call it again in the class definition
      # # to override the default (or provide a value, if the default lookup failed).
      # def self.edge_type(edge_type_class, edge_class: GraphQL::Relay::Edge, node_type: nil)
      #   # Add the edges field, can be overridden later
      #   field :edges, [edge_type_class, null: true],
      #     null: true,
      #     description: "A list of edges.",
      #     method: :edge_nodes,
      #     edge_class: edge_class

      #   # Try to figure out what the node type is, if it wasn't provided:
      #   if node_type.nil?
      #     if edge_type_class.is_a?(Class)
      #       node_type = edge_type_class.fields["node"].type
      #     elsif edge_type_class.is_a?(GraphQL::ObjectType)
      #       # This was created with `.edge_type`
      #       node_type = Types.const_get(edge_type_class.name.sub("Edge", ""), false)
      #     else
      #       raise ArgumentError, "Can't get node type from edge type: #{edge_type_class}"
      #     end
      #   end

      #   # If it's a non-null type, remove the wrapper
      #   node_type = node_type.of_type if node_type.respond_to?(:of_type)

      #   # Make the `nodes` shortcut field, which can be overridden later
      #   field :nodes, [node_type, null: true],
      #     null: true,
      #     description: "A list of nodes."

      #   # Make a nice description
      #   description("The connection type for #{node_type.graphql_name}.")
      # end

      # field :page_info, GraphQL::Relay::PageInfo, "Information to aid in pagination.",
      #   null: false

      # # Add the total_count field to all connections:
      # field :total_count, Integer, "The total count of edges in this connection", null: false

      # def total_count
      #   # This implementation works in my own Sequel StableRelationConnection and should work
      #   # in the regular one. The key is to make sure you call count on the dataset/relation,
      #   # not the list of nodes for this particular page of results.
      #   #
      #   # My relation connection:
      #   # https://github.com/rmosolgo/graphql-ruby/pull/1014
      #   @object.nodes.count
      # end

      # # By default this calls through to the ConnectionWrapper's edge nodes method,
      # # but sometimes you need to override it to support the `nodes` field
      # def nodes
      #   @object.edge_nodes
      # end
    end
  end
end

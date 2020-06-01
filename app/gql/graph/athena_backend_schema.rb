module Graph
  class AthenaBackendSchema < GraphQL::Schema
    mutation(Types::MutationType)
    query(Types::QueryType)

    # Opt in to the new runtime (default in future graphql-ruby versions)
    use GraphQL::Execution::Interpreter
    use GraphQL::Analysis::AST
    use GraphQL::Execution::Errors

    # Add built-in connections for pagination
    use GraphQL::Pagination::Connections
    use GraphQL::Batch
    use GraphQL::Backtrace

    rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
      raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
    end
  end
end

# QuickCrud

**Generate CRUD functions for your Ecto schemas with zero boilerplate.**

QuickCrud is an Elixir library that automatically generates common CRUD operations for your Ecto schemas using macros. Instead of writing repetitive context functions, define them once and get a full suite of database operations.

## Why QuickCrud?

- 🚀 **Zero Boilerplate**: Generate 20+ CRUD functions with a few macro calls
- 🎯 **Phoenix Context Ready**: Perfect for Phoenix contexts and clean architecture
- 🔧 **Highly Customizable**: Add custom changesets, associations, and query logic
- 📚 **Ecto Native**: Built on top of Ecto.Query - no magic, just convenience
- ⚡ **Developer Friendly**: Intuitive function names and comprehensive documentation

## Quick Start

Add QuickCrud to your dependencies:

```elixir
def deps do
  [
    {:quick_crud, "~> 0.1.0"}
  ]
end
```

Define your context with generated CRUD operations:

```elixir
defmodule MyApp.Accounts do
  require QuickCrud
  import Ecto.Query

  ## in case you want to override the singular name, provide it explicitly:
  ## @resource QuickCrud.config(User, MyApp.Repo, plural: "users", singular: "user")
  @resource QuickCrud.config(User, MyApp.Repo, plural: "users")

  # Generate common CRUD functions
  QuickCrud.list(@resource)
  QuickCrud.get!(@resource)
  QuickCrud.get(@resource)
  QuickCrud.create(@resource, &User.changeset/2)
  QuickCrud.update(@resource, &User.changeset/2)
  QuickCrud.delete(@resource)

  # Generate helpful utilities
  QuickCrud.paginate(@resource)
  QuickCrud.get_by_attr(@resource, :email)
  QuickCrud.preload(@resource, :posts)
  QuickCrud.order_by(@resource, :inserted_at, :desc)
end
```

Now you have a full suite of functions:

```elixir
# Basic CRUD
{:ok, user} = Accounts.create_user(%{name: "Alice", email: "alice@example.com"})
users = Accounts.list_users()
user = Accounts.get_user!(123)
{:ok, updated_user} = Accounts.update_user(user, %{name: "Alice Smith"})
{:ok, _} = Accounts.delete_user(user)

# Utilities
user = Accounts.get_user_by_email("alice@example.com")
%{entries: users, total: count} = Accounts.paginate_users([], 1, 10)
users = Accounts.list_users(preload: [:posts, :company])
```

## Generated Functions

### Core CRUD Operations

| Macro | Generated Function | Description |
|-------|-------------------|-------------|
| `list/1` | `list_users/1` | List all records with optional filtering |
| `get/1` | `get_user/2` | Get record by ID (returns nil if not found) |
| `get!/1` | `get_user!/2` | Get record by ID (raises if not found) |
| `create/2` | `create_user/1` | Create new record |
| `update/2` | `update_user/2` | Update existing record |
| `delete/1` | `delete_user/1` | Delete record |
| `change/2` | `change_user/2` | Generate changeset for forms |

### Query Helpers

| Macro | Generated Function | Description |
|-------|-------------------|-------------|
| `paginate/1` | `paginate_users/3` | Paginated results with metadata |
| `get_by_attr/2` | `get_user_by_email/2` | Find by specific attribute |
| `preload/2` | `preload_user_posts/1` | Add preload to query |
| `join/2` | `join_user_company/1` | Join with association |
| `order_by/3` | `order_users_by_name/1` | Add ordering to query |
| `filter_by_one/2` | `filter_users_by_company/2` | Filter by association |

## Advanced Usage

### Complex Queries with Filtering

```elixir
# Filter with where conditions
users = Accounts.list_users(
  where: [active: true, role: "admin"]
)

# OR conditions
users = Accounts.list_users(
  where: {[], [role: "admin"], or: [role: "moderator"]}
)

# With preloads and ordering
users = Accounts.list_users(
  where: [active: true],
  preload: [:company, :posts],
  order_by: [desc: :inserted_at]
)
```

### Association Helpers

```elixir
# Get user belonging to a company
QuickCrud.get_for!(@resource, :company)
user = Accounts.get_user_for_company!(company)

# Filter users by company
QuickCrud.filter_by_one(@resource, :company)
users = Accounts.filter_users_by_company(query, company)
```

### Custom Upserts

```elixir
# Upsert with custom conflict resolution
QuickCrud.upsert(@resource, &User.changeset/2,
  on_conflict: {:replace, [:name, :updated_at]},
  conflict_target: :email
)
```

### Pagination

```elixir
# Get paginated results
%{entries: users, total: total_count, page: 1, per_page: 10} =
  Accounts.paginate_users([], 1, 10)

# With filtering
%{entries: users, total: total_count} =
  Accounts.paginate_users([where: [active: true]], 2, 25)
```

## Configuration

The `QuickCrud.config/3` function sets up your resource configuration:

```elixir
@resource QuickCrud.config(
  User,           # Your Ecto schema
  MyApp.Repo,     # Your Ecto repo
  "users"         # Plural name for function generation
)
```

## Philosophy

QuickCrud follows Phoenix context conventions and generates functions that feel natural in your application. It doesn't replace custom business logic - it eliminates the repetitive CRUD boilerplate so you can focus on what makes your application unique.

## Requirements

- Elixir 1.12+
- Ecto 3.0+

## Documentation

Full documentation is available at [https://hexdocs.pm/quick_crud](https://hexdocs.pm/quick_crud).

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

QuickCrud is released under the MIT License. See [LICENSE](LICENSE) for details.

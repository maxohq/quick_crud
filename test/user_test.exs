defmodule UserTest do
  use ExUnit.Case, async: true
  alias QuickCrud.{Repo, User}

  defmodule UserContext do
    require QuickCrud
    import Ecto.Query
    @resource QuickCrud.config(User, Repo, plural: "users")

    # Common CRUD functions
    QuickCrud.list(@resource)
    QuickCrud.get!(@resource)
    QuickCrud.get(@resource)
    QuickCrud.new(@resource)
    QuickCrud.create(@resource, &User.changeset/2)
    QuickCrud.change(@resource, &User.changeset/2)
    QuickCrud.update(@resource, &User.changeset/2)
    QuickCrud.delete(@resource)

    # CRUD helpers
    QuickCrud.paginate(@resource)
    QuickCrud.get_for!(@resource, :company)
    QuickCrud.get_for(@resource, :company)
    QuickCrud.get_by_attr!(@resource, :username)
    QuickCrud.get_by_attr(@resource, :username)
    QuickCrud.preload(@resource, :posts)
    QuickCrud.preload(@resource, :company)
    QuickCrud.preload(@resource, :likes)
    QuickCrud.order_by(@resource, :username, :desc)
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    :ok
  end

  require QuickCrud.Testing

  @resource QuickCrud.Testing.config(UserContext,
              schema: User,
              repo: Repo,
              plural: "users",
              factory: QuickCrud.Factory
            )
  QuickCrud.Testing.list(@resource)
  QuickCrud.Testing.get(@resource)
  QuickCrud.Testing.get!(@resource)
  QuickCrud.Testing.create(@resource, %{username: "username1"})
  QuickCrud.Testing.update(@resource, %{username: "changed"})
  QuickCrud.Testing.delete(@resource)
  QuickCrud.Testing.paginate(@resource)
end

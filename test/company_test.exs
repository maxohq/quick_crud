defmodule CompanyTest do
  use ExUnit.Case, async: true
  alias QuickCrud.{Repo, Company}

  defmodule CompanyContext do
    require QuickCrud
    import Ecto.Query
    @resource QuickCrud.config(Company, Repo, "companies")

    # Common CRUD functions
    QuickCrud.list(@resource)
    QuickCrud.get!(@resource)
    QuickCrud.get(@resource)
    QuickCrud.new(@resource)
    QuickCrud.create(@resource, &Company.changeset/2)
    QuickCrud.change(@resource, &Company.changeset/2)
    QuickCrud.update(@resource, &Company.changeset/2)
    QuickCrud.delete(@resource)

    # CRUD helpers
    QuickCrud.paginate(@resource)
    QuickCrud.get_by_attr!(@resource, :name)
    QuickCrud.get_by_attr(@resource, :name)
    QuickCrud.preload(@resource, :users)
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    :ok
  end

  require QuickCrud.Testing

  @resource QuickCrud.Testing.config(CompanyContext,
              schema: Company,
              repo: Repo,
              plural: "companies",
              factory: QuickCrud.Factory
            )
  QuickCrud.Testing.list(@resource)
  QuickCrud.Testing.get(@resource)
  QuickCrud.Testing.get!(@resource)
  QuickCrud.Testing.create(@resource, %{name: "Company 1"})
  QuickCrud.Testing.update(@resource, %{name: "Company 1"})
  QuickCrud.Testing.delete(@resource)
  QuickCrud.Testing.paginate(@resource)

  test "list" do
    QuickCrud.Factory.insert(:company)
    res = CompanyContext.list_companies()
    assert Enum.count(res) == 1
  end
end

defmodule QuickCrud.Company do
  use Ecto.Schema
  import Ecto.Changeset
  use QueryBuilder, assoc_fields: [:users]

  schema "companies" do
    field(:name, :string)
    has_many(:users, QuickCrud.User)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end
end

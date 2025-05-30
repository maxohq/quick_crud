defmodule QuickCrud.Comment do
  use Ecto.Schema
  use QueryBuilder, assoc_fields: [:post]
  import Ecto.Changeset

  schema "comments" do
    field(:content, :string)
    belongs_to(:post, QuickCrud.Post)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :post_id])
    |> validate_required([:content, :post_id])
    |> foreign_key_constraint(:post_id)
  end
end

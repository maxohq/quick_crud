defmodule QuickCrud.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    belongs_to(:user, QuickCrud.User)
    has_many(:likes, QuickCrud.Like)
    has_one(:comment, QuickCrud.Comment)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
  end

  @doc false
  def nested_changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title])
    |> foreign_key_constraint(:user_id)
  end

  def nested_likes_changeset(post, attrs) do
    post
    |> changeset(attrs)
    |> cast_assoc(:likes, with: &QuickCrud.Like.changeset/2)
  end

  def nested_comment_changeset(post, attrs) do
    post
    |> changeset(attrs)
    |> cast_assoc(:comment, with: &QuickCrud.Comment.changeset/2)
  end
end

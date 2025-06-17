defmodule QuickCrudCommentTest do
  use ExUnit.Case, async: true
  alias QuickCrud.{Repo, Comment}

  defmodule CommentsContext do
    require QuickCrud
    import Ecto.Query
    @resource QuickCrud.config(Comment, Repo, plural: "comments")

    # Common CRUD functions
    QuickCrud.list(@resource)
    QuickCrud.get!(@resource)
    QuickCrud.get(@resource)
    QuickCrud.new(@resource)
    QuickCrud.create(@resource, &Comment.changeset/2)
    QuickCrud.change(@resource, &Comment.changeset/2)
    QuickCrud.update(@resource, &Comment.changeset/2)
    QuickCrud.delete(@resource)

    # CRUD helpers
    QuickCrud.paginate(@resource)
    QuickCrud.get_by_attr!(@resource, :content)
    QuickCrud.get_by_attr(@resource, :content)
    QuickCrud.preload(@resource, :posts)
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    :ok
  end

  require QuickCrud.Testing

  @resource QuickCrud.Testing.config(CommentsContext,
              schema: Comment,
              repo: Repo,
              plural: "comments",
              factory: QuickCrud.Factory
            )
  QuickCrud.Testing.list(@resource)
  QuickCrud.Testing.get(@resource)
  QuickCrud.Testing.get!(@resource)

  QuickCrud.Testing.create(@resource, %{content: "Content"}, fn config ->
    p = config.factory.insert(:post)
    %{post_id: p.id}
  end)

  QuickCrud.Testing.update(@resource, %{content: "Content"}, fn config ->
    p = config.factory.insert(:post)
    %{post_id: p.id}
  end)

  QuickCrud.Testing.delete(@resource)
  QuickCrud.Testing.paginate(@resource)
end

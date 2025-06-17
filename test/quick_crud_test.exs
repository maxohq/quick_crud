defmodule QuickCrudTest do
  use ExUnit.Case, async: true

  alias QuickCrud.{Repo, User}
  import QuickCrud.Factory

  @user %{username: "Bruce Lee", age: 2025 - 1940, bio: "Bruce Lee - the legend"}
  @user2 %{username: "Bruce Willis", age: 2025 - 1955, bio: "Die Hard"}
  @user3 %{username: "Jason Statham", age: 2025 - 1967, bio: "The Transporter"}

  defmodule UserContext do
    # https://elixirforum.com/t/prototyping-and-enforcing-context-function-conventions/38821/2
    # trying https://gist.github.com/baldwindavid/7da385f0e79cbee62331d5be0b8c75db

    require QuickCrud
    import Ecto.Query

    @resource QuickCrud.config(User, Repo, plural: "users")

    # Common CRUD functions
    QuickCrud.list(@resource)
    QuickCrud.get!(@resource)
    QuickCrud.get(@resource)
    QuickCrud.new(@resource)
    QuickCrud.create(@resource, &User.changeset/2)
    QuickCrud.upsert(@resource, &User.changeset/2)
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
    QuickCrud.join(@resource, :company)
    QuickCrud.filter_by_one(@resource, :company)
    # QuickCrud.filter_by_one_or_many(@resource, :unit_type)
    QuickCrud.order_by(@resource, :username, :desc)
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    :ok
  end

  test "list_users works" do
    insert(:user, @user)
    insert(:user, @user2)
    insert(:user, @user3)

    res = UserContext.list_users()
    assert Enum.count(res) == 3

    ## OR query (somewhat tricky syntax, with a tuple of [], filters, or_filters)
    res =
      UserContext.list_users(where: {[], [username: "Bruce Lee"], or: [username: "Bruce Willis"]})

    assert Enum.at(res, 0).username == "Bruce Lee"
    assert Enum.at(res, 1).username == "Bruce Willis"
    assert Enum.count(res) == 2

    ## with preloads
    res = UserContext.list_users(preload: [:company, :posts])
    assert Enum.at(res, 0).username == "Bruce Lee"
    assert Enum.at(res, 0).company.name
    assert Enum.at(res, 0).posts == []
    assert Enum.at(res, 1).username == "Bruce Willis"
    assert Enum.at(res, 1).company.name
    assert Enum.at(res, 1).posts == []
    assert Enum.at(res, 2).username == "Jason Statham"
    assert Enum.at(res, 2).company.name
    assert Enum.at(res, 2).posts == []
    assert Enum.count(res) == 3
  end

  test "get_user works" do
    insert(:user)
    insert(:user)
    [user1, _user2] = UserContext.list_users()
    assert user1 == UserContext.get_user(user1.id)
  end

  test "create_user works" do
    {:ok, user1} = UserContext.create_user(%{username: "user1"})
    assert user1 == UserContext.get_user_by_username("user1")
  end

  test "upsert_user works (ignore conflicts on inserts by default)" do
    {:ok, user1} = UserContext.upsert_user(%{username: "user1"})
    {:ok, _user1_duplicate} = UserContext.upsert_user(%{username: "user1"})
    assert user1 == UserContext.get_user_by_username("user1")
  end

  test "change_user works with 2 args" do
    {:ok, user1} = UserContext.create_user(%{username: "user1"})
    assert user1 == UserContext.get_user_by_username("user1")
    changeset = UserContext.change_user(user1, %{bio: "CHANGED"})
    assert changeset.changes.bio == "CHANGED"
  end

  test "change_user works with 1 arg" do
    {:ok, user1} = UserContext.create_user(%{username: "user1"})
    assert user1 == UserContext.get_user_by_username("user1")
    changeset = UserContext.change_user(user1)
    assert changeset.changes == %{}
  end

  test "update_user works" do
    {:ok, user1} = UserContext.create_user(%{username: "user1"})
    assert user1 == UserContext.get_user_by_username("user1")
    {:ok, user1_changed} = UserContext.update_user(user1, %{bio: "CHANGED"})
    assert user1_changed.bio == "CHANGED"
    user1_new = UserContext.get_user_by_username("user1")
    assert user1_new.bio == "CHANGED"
  end

  test "delete_user works" do
    {:ok, user1} = UserContext.create_user(%{username: "user1"})
    assert user1 == UserContext.get_user_by_username("user1")
    {:ok, _user1_deleted} = UserContext.delete_user(user1)
    assert nil == UserContext.get_user_by_username("user1")
  end
end

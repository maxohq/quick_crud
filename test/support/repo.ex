defmodule QuickCrud.Repo do
  use Ecto.Repo,
    otp_app: :quick_crud,
    adapter: Ecto.Adapters.Postgres
end

import Config

config :quick_crud, ecto_repos: [QuickCrud.Repo]
import_config "#{Mix.env()}.exs"

import Config

config :quick_crud, QuickCrud.Repo,
  database: "quick_crud_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  poolsize: 10

import Config

config :quick_crud, QuickCrud.Repo,
  database: "quick_crud_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  poolsize: 10,
  pool: Ecto.Adapters.SQL.Sandbox,
  # in ms
  ownership_timeout: 12_000_000

config :logger, level: :warning
# config :logger, level: :debug

##### Maxo TestIEx
# for default values look into:
# - https://github.com/maxohq/maxo_test_iex/blob/main/lib/test_iex/config.ex

# NO need to watch for tests on CI
if System.get_env("CI"), do: config(:maxo_test_iex, watcher_enable: false)

# how long multiple consecutive events on the same file should be considered duplicates?
config :maxo_test_iex, watcher_dedup_timeout: 500

# which file changes should trigger a test re-run?
config :maxo_test_iex, watcher_args: [dirs: ["lib/", "test/"], latency: 0]

# which file extensions are relevant to trigger a test re-run?
config :maxo_test_iex, watcher_extensions: [".ex", ".exs"]

# should we log debug messages?
config :maxo_test_iex, debug: false

import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :recipebook, Recipebook.Repo,
  database: "recipebook_test_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :recipebook, RecipebookWeb.Endpoint,
  http: [port: 4002],
  server: false

config :ecto_shorts,
  repo: Recipebook.Repo,
  error_module: EctoShorts.Actions.Error

# Print only warnings and errors during test
config :logger, level: :warn

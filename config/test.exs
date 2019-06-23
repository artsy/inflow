use Mix.Config

# Configure your database
config :inflow, Inflow.Repo,
  username: "postgres",
  password: "postgres",
  database: "inflow_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :inflow, InflowWeb.Endpoint,
  http: [port: 4002],
  server: false,
  live_view: [
    signing_salt: "test_signing_salt"
  ]

# Print only warnings and errors during test
config :logger, level: :warn

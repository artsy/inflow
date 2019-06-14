# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :inflow,
  ecto_repos: [Inflow.Repo]

# Configures the endpoint
config :inflow, InflowWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k3ih10Xby7rsD4h/ObGWX8agOH8BjLSMJevtOx0KZadb/UsE695NQ2Zl6malRLcL",
  render_errors: [view: InflowWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Inflow.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

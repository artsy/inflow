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

config :inflow, Gravity,
  api_url: System.get_env("GRAVITY_API_URL"),
  api_token: System.get_env("GRAVITY_API_TOKEN")

config :artsy_auth_ex,
  token_aud: System.get_env("ARTSY_TOKEN_AUD"), # aud of your JWT token, Gravity's ClientApplication.id
  client_id: System.get_env("ARTSY_CLIENT_ID"), # Gravity's ClientApplication.app_id
  client_secret: System.get_env("ARTSY_CLIENT_SECRET"), # Gravity's ClientApplication.app_secret
  redirect_uri: Map.get(System.get_env(), "HOST_URL", "http://localhost:4000") <> "/auth/callback",
  site: System.get_env("ARTSY_URL"), # Gravity's api url ex. https://stagingapi.artsy.net
  authorize_url: "/oauth2/authorize",
  token_url: "/oauth2/access_token",
  allowed_roles: ["admin"] # list of roles allowed to access your app

config :joken,
  default_signer: System.get_env("ARTSY_INTERNAL_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

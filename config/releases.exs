import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
signing_salt = System.fetch_env!("SIGNING_SALT")
application_port = System.fetch_env!("APP_PORT")

config :inflow, InflowWeb.Endpoint,
  http: [:inet6, port: String.to_integer(application_port)],
  url: [host: System.fetch_env!("HOST_URL"), port: 80],
  secret_key_base: secret_key_base,
  live_view: [
    signing_salt: signing_salt
  ]

config :inflow, Inflow.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE") || "10")

config :inflow, Gravity,
  api_url: System.fetch_env!("GRAVITY_API_URL") || "https://stagingapi.artsy.net",
  api_token: System.fetch_env!("GRAVITY_API_TOKEN")

config :artsy_auth_ex,
  # aud of your JWT token, Gravity's ClientApplication.id
  token_aud: System.fetch_env!("ARTSY_TOKEN_AUD"),
  # Gravity's ClientApplication.app_id
  client_id: System.fetch_env!("ARTSY_CLIENT_ID"),
  # Gravity's ClientApplication.app_secret
  client_secret: System.fetch_env!("ARTSY_CLIENT_SECRET"),
  redirect_uri:
    Map.get(System.get_env(), "HOST_URL", "http://localhost:4000") <> "/auth/callback",
  # Gravity's api url ex. https://stagingapi.artsy.net
  site: System.fetch_env!("ARTSY_URL"),
  authorize_url: "/oauth2/authorize",
  token_url: "/oauth2/access_token",
  # list of roles allowed to access your app
  allowed_roles: ["admin"]

config :joken,
  default_signer: System.fetch_env!("ARTSY_INTERNAL_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  access_key_id: [System.fetch_env!("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.fetch_env!("AWS_SECRET_ACCESS_KEY"), :instance_role]

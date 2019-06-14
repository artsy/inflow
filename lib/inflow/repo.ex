defmodule Inflow.Repo do
  use Ecto.Repo,
    otp_app: :inflow,
    adapter: Ecto.Adapters.Postgres
end

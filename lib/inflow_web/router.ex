defmodule InflowWeb.Router do
  use InflowWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Artsy.Auth.Plug
  end

  scope "/", InflowWeb do
    pipe_through [:browser, :authenticated]

    live "/", DashboardView, session: [:access_token]

    resources("/manifests", ManifestsController, only: [:index, :new, :create, :show])
  end

  scope "/auth", InflowWeb do
    pipe_through :browser

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
    get "/signout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", InflowWeb do
  #   pipe_through :api
  # end
end

defmodule InflowWeb.PageController do
  use InflowWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

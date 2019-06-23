defmodule InflowWeb.ManifestsController do
  use InflowWeb, :controller
  alias Inflow.{Import, Import.Manifest}

  def index(conn, %{"partner_id" => partner_id}) do
    render(conn, "index.html",
      manifests: Import.list_manifests(),
      partner_id: partner_id
    )
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    render(conn, "show.html", manifest: %{id: id})
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Import.change_manifest(%Manifest{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"manifest" => %{"import_file" => uploaded_file}}) do
    with {:ok, manifest} <-
           Import.start_upload(
             uploaded_file.path,
             uploaded_file.filename,
             "510afead4926534fd8000683",
             false
           ) do
      conn
      |> put_flash(:info, "Started Upload Process")
      |> redirect(to: Routes.manifests_path(conn, :show, manifest))
    else
      _ ->
        conn
        |> put_flash(:error, "something went wrong")
        |> redirect(to: Routes.manifests_path(conn, :new))
    end
  end
end

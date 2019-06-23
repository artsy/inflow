defmodule InflowWeb.ManifestsController do
  use InflowWeb, :controller
  alias Inflow.{Import, Import.Manifest}
  @gravity_api Application.get_env(:inflow, :gravity_api)

  def index(conn, %{"partner_id" => partner_id}) do
    partner = @gravity_api.get!("/api/v1/partner/#{partner_id}").body
    conn
    |> put_session(:partner_id, partner_id)
    |> render("index.html", manifests: Import.list_manifests(), partner: partner)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    render(conn, "show.html", manifest: %{id: id})
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, %{"partner_id" => partner_id}) do
    changeset = Import.change_manifest(%Manifest{partner_id: partner_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"manifest" => %{"import_file" => uploaded_file, "partner_id" => partner_id}}) do
    with {:ok, manifest} <-
           Import.start_upload(
             uploaded_file.path,
             uploaded_file.filename,
             partner_id,
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

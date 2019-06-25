defmodule InflowWeb.ManifestLiveView do
  use Phoenix.LiveView
  alias Inflow.Import.Manifest
  @topic "manifests:"

  def render(assigns) do
    ~L"""
    <%= if @loading do %>
      <div> Loading </div>
    <% else %>
      <div><strong> <%= @manifest.state %> </strong></div>
      <table class="manifest-row-section">
        <%= for mr <- @manifest_rows do %>
          <tr class="manifest-row">
            <td> <%= mr.name %></td>
            <td> <%= mr.title %></td>
          </tr>
        <% end %>
      </table>
    <% end %>
    """
  end

  def mount(session, socket) do
    manifest_id = session.manifest_id
    if connected?(socket) do
      InflowWeb.Endpoint.subscribe(@topic <> manifest_id)
      send(self(), :initialize)
    end
    {:ok,
     assign(socket,
       id: manifest_id,
       manifest: nil,
       loading: true,
       manifest_rows: [],
       access_token: session.access_token
     )}
  end

  def handle_info(:initialize, socket) do
    manifest = Inflow.Import.get_manifest!(socket.assigns.id)
    {:noreply, assign(socket, manifest: manifest, loading: false)}
  end

  def handle_info(%{event: "manifest_updated", payload: %{state: state}}, socket) do
    {:noreply, assign(socket, manifest: %Manifest{socket.assigns.manifest | state: state})}
  end

  def handle_info(%{event: "manifest_row_created", payload: %{manifest_row: manifest_row}}, socket) do
    {:noreply, assign(socket, manifest_rows: socket.assigns.manifest_rows ++ [manifest_row])}
  end
end

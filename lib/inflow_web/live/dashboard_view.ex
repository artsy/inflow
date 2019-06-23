defmodule InflowWeb.DashboardView do
  use Phoenix.LiveView
  @gravity_api Application.get_env(:inflow, :gravity_api)

  def render(assigns) do
    ~L"""
    <form phx-change="suggest" phx-submit="select">
      <input type="text" name="q" value="<%= @query %>" list="matches"
             placeholder="Search..."
             <%= if @loading, do: "readonly" %>/>
      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value="<%= match["_id"] %>" phx-click="select<%= match["_id"] %>"> <%= match["name"] %></option>
        <% end %>
      </datalist>
      <%= if @result do %><pre><%= @result %></pre><% end %>
    </form>
    """
  end

  def mount(session, socket) do
    {:ok,
     assign(socket,
       query: nil,
       result: nil,
       loading: false,
       matches: [],
       access_token: session.access_token
     )}
  end

  def handle_event("suggest", %{"q" => q}, socket) when byte_size(q) <= 100 do
    matches = fetch_partners(q, socket.assigns.access_token)
    {:noreply, assign(socket, matches: matches)}
  end

  def handle_event("select", %{"q" => q}, socket) do
    {:stop,
     socket
     |> put_flash(:info, "Partner Selected")
     |> redirect(to: InflowWeb.Router.Helpers.manifests_path(socket, :index, %{partner_id: q}))}
  end

  defp fetch_partners(term, token) do
    @gravity_api.get!("/api/v1/match/partners?term=#{term}", [{:"X-ACCESS-TOKEN", token}]).body
    |> Enum.map(fn partner -> Map.take(partner, ["_id", "name"]) end)
  end
end

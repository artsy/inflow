defmodule InflowWeb.DashboardView do
  use Phoenix.LiveView
  @gravity_api Application.get_env(:inflow, :gravity_api)

  @access_token "replace-with-user-token"

  def render(assigns) do
    ~L"""
    <form phx-change="suggest" phx-submit="search">
      <input type="text" name="q" value="<%= @query %>" list="matches"
             placeholder="Search..."
             <%= if @loading, do: "readonly" %>/>
      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value="<%= match["_id"] %>"><%= match["name"] %></option>
        <% end %>
      </datalist>
      <%= if @result do %><pre><%= @result %></pre><% end %>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, query: nil, result: nil, loading: false, matches: [])}
  end

  def handle_event("suggest", %{"q" => q}, socket) when byte_size(q) <= 100 do
    matches = fetch_partners(q)
    {:noreply, assign(socket, matches: matches)}
  end

  def handle_event("search", %{"q" => q}, socket) when byte_size(q) <= 100 do
    send(self(), {:search, q})
    {:noreply, assign(socket, query: q, result: "…", loading: true, matches: [])}
  end

  def handle_info({:search, query}, socket) do
    {result, _} = System.cmd("dict", ["#{query}"], stderr_to_stdout: true)
    {:noreply, assign(socket, loading: false, result: result, matches: [])}
  end

  defp fetch_partners(term) do
    @gravity_api.get!("/api/v1/match/partners?term=#{term}", [{:"X-ACCESS-TOKEN", @access_token}]).body
    |> Enum.map( fn partner -> Map.take(partner, ["_id", "name"]) end )
  end
end
defmodule WawShowcaseWeb.ComponentDetailLive do
  use WawShowcaseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"component" => component_name}, _uri, socket) do
    {:noreply, assign(socket, component_name: component_name)}
  end
end

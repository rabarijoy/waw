defmodule WawShowcaseWeb.ComponentsLive do
  use WawShowcaseWeb, :live_view
  use WawShowcaseWeb.Live.ComponentInspector

  @impl true
  def mount(_params, _session, socket) do
    components = WawShowcase.ComponentExtractor.load_components()

    {:ok,
     socket
     |> assign(:components, components)
     |> assign(:search_term, "")
     |> assign(:filtered_components, components)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search_term}, socket) do
    filtered =
      if String.trim(search_term) == "" do
        socket.assigns.components
      else
        search_term_lower = String.downcase(search_term)

        Enum.filter(socket.assigns.components, fn component ->
          String.contains?(String.downcase(component.nom || ""), search_term_lower) ||
            String.contains?(String.downcase(component.module || ""), search_term_lower)
        end)
      end

    {:noreply,
     socket
     |> assign(:search_term, search_term)
     |> assign(:filtered_components, filtered)}
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    # Vider le cache et recharger
    WawShowcase.Cache.delete(:waw_components)
    components = WawShowcase.ComponentExtractor.load_components()

    {:noreply,
     socket
     |> assign(:components, components)
     |> assign(:filtered_components, components)
     |> put_flash(:info, "Composants rechargés avec succès")}
  end
end





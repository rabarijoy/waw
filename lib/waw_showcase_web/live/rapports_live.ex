defmodule WawShowcaseWeb.RapportsLive do
  use WawShowcaseWeb, :live_view
  use WawShowcaseWeb.Live.ComponentInspector

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:active_tab, "general")
      |> assign(:vehicules_loaded, false)

    # Charger les données pour l'onglet "general" par défaut
    socket = load_vehicules_if_needed(socket)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    socket =
      case tab do
        "general" ->
          load_vehicules_if_needed(socket)

        "vehicule" ->
          load_vehicules_if_needed(socket)

        _ ->
          socket
      end

    {:noreply, assign(socket, :active_tab, tab)}
  end

  defp load_vehicules_if_needed(socket) do
    if socket.assigns[:vehicules_loaded] do
      socket
    else
      vehicules = generate_sample_vehicules()
      socket
      |> stream(:vehicules, vehicules, reset: true)
      |> assign(:vehicules_loaded, true)
    end
  end

  defp generate_sample_vehicules do
    [
      %{id: "rapport-vehicule-1", nom: "Voiture 1", entrees_carburant: 12, cout_carburant: 850.50, cout_maintenance: 320.00},
      %{id: "rapport-vehicule-2", nom: "Voiture 2", entrees_carburant: 10, cout_carburant: 720.30, cout_maintenance: 280.50},
      %{id: "rapport-vehicule-3", nom: "Camion 1", entrees_carburant: 15, cout_carburant: 1250.75, cout_maintenance: 450.00},
      %{id: "rapport-vehicule-4", nom: "Voiture 3", entrees_carburant: 8, cout_carburant: 580.20, cout_maintenance: 210.00}
    ]
  end
end

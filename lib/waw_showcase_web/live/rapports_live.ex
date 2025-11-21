defmodule WawShowcaseWeb.RapportsLive do
  use WawShowcaseWeb, :live_view
  use WawShowcaseWeb.Live.ComponentInspector

  @impl true
  def mount(_params, _session, socket) do
    vehicules = generate_sample_vehicules()

    {:ok,
     socket
     |> assign(:active_tab, "general")
     |> assign(:vehicules, vehicules)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  defp generate_sample_vehicules do
    [
      %{nom: "Voiture 1", entrees_carburant: 12, cout_carburant: 850.50, cout_maintenance: 320.00},
      %{nom: "Voiture 2", entrees_carburant: 10, cout_carburant: 720.30, cout_maintenance: 280.50},
      %{nom: "Camion 1", entrees_carburant: 15, cout_carburant: 1250.75, cout_maintenance: 450.00},
      %{nom: "Voiture 3", entrees_carburant: 8, cout_carburant: 580.20, cout_maintenance: 210.00},
      %{nom: "Camion 2", entrees_carburant: 18, cout_carburant: 1520.40, cout_maintenance: 520.00}
    ]
  end
end

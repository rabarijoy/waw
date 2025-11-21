defmodule WawShowcaseWeb.CarburantLive do
  use WawShowcaseWeb, :live_view
  use WawShowcaseWeb.Live.ComponentInspector

  @impl true
  def mount(_params, _session, socket) do
    vehicules = generate_sample_vehicules()
    entries = generate_sample_entries()
    fuel_cards = generate_fuel_cards()
    vehicule_options = [{"", "Sélectionner un véhicule"}] ++ Enum.map(vehicules, fn v -> {v, v} end)

    {:ok,
     socket
     |> assign(:show_modal, false)
     |> assign(:vehicules, vehicules)
     |> assign(:vehicule_options, vehicule_options)
     |> assign(:entries, entries)
     |> assign(:fuel_cards, fuel_cards)
     |> assign(:form_data, %{
       vehicule: "",
       date: nil,
       litres: nil,
       prix_litre: nil
     })}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("open_modal", _params, socket) do
    {:noreply, assign(socket, :show_modal, true)}
  end

  @impl true
  def handle_event("close_modal", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_modal, false)
     |> assign(:form_data, %{
       vehicule: "",
       date: nil,
       litres: nil,
       prix_litre: nil
     })}
  end

  @impl true
  def handle_event("save_entry", _params, socket) do
    # Ici on pourrait sauvegarder l'entrée
    # Pour l'instant, on ferme juste le modal
    {:noreply,
     socket
     |> assign(:show_modal, false)
     |> assign(:form_data, %{
       vehicule: "",
       date: nil,
       litres: nil,
       prix_litre: nil
     })}
  end

  @impl true
  def handle_event("update_form", params, socket) do
    form_data = Map.merge(socket.assigns.form_data, params)
    {:noreply, assign(socket, :form_data, form_data)}
  end

  defp generate_sample_vehicules do
    [
      "Voiture 1",
      "Voiture 2",
      "Camion 1",
      "Voiture 3",
      "Camion 2",
      "Voiture 4",
      "Fourgon 1",
      "Voiture 5",
      "Camion 3",
      "Voiture 6",
      "Fourgon 2",
      "Voiture 7"
    ]
  end

  defp generate_fuel_cards do
    [
      %{vehicule: "Voiture 1", value: "35", number: "1510", title: "Consommation totale de carburant"},
      %{vehicule: "Voiture 2", value: "28", number: "1200", title: "Consommation totale de carburant"},
      %{vehicule: "Camion 1", value: "85", number: "3200", title: "Consommation totale de carburant"},
      %{vehicule: "Voiture 3", value: "32", number: "1380", title: "Consommation totale de carburant"},
      %{vehicule: "Camion 2", value: "92", number: "3450", title: "Consommation totale de carburant"},
      %{vehicule: "Voiture 4", value: "26", number: "1100", title: "Consommation totale de carburant"},
      %{vehicule: "Fourgon 1", value: "45", number: "1800", title: "Consommation totale de carburant"},
      %{vehicule: "Voiture 5", value: "30", number: "1250", title: "Consommation totale de carburant"},
      %{vehicule: "Camion 3", value: "88", number: "3300", title: "Consommation totale de carburant"},
      %{vehicule: "Voiture 6", value: "29", number: "1220", title: "Consommation totale de carburant"},
      %{vehicule: "Fourgon 2", value: "42", number: "1750", title: "Consommation totale de carburant"},
      %{vehicule: "Voiture 7", value: "33", number: "1400", title: "Consommation totale de carburant"}
    ]
  end

  defp generate_sample_entries do
    [
      %{vehicule: "Voiture 1", date: ~U[2025-01-15 10:30:00Z], litres: 45.5, prix_litre: 1.65},
      %{vehicule: "Camion 1", date: ~U[2025-01-14 14:20:00Z], litres: 80.0, prix_litre: 1.70},
      %{vehicule: "Voiture 2", date: ~U[2025-01-13 09:15:00Z], litres: 52.3, prix_litre: 1.68},
      %{vehicule: "Voiture 3", date: ~U[2025-01-12 16:45:00Z], litres: 38.2, prix_litre: 1.65},
      %{vehicule: "Camion 2", date: ~U[2025-01-11 11:00:00Z], litres: 95.5, prix_litre: 1.72}
    ]
  end

end

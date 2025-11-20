defmodule WawShowcaseWeb.CarburantLive do
  use WawShowcaseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    vehicules = generate_sample_vehicules()
    entries = generate_sample_entries()
    
    {:ok,
     socket
     |> assign(:show_modal, false)
     |> assign(:vehicules, vehicules)
     |> assign(:entries, entries)
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
      "Camion 2"
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


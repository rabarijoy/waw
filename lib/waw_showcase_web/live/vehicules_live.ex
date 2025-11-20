defmodule WawShowcaseWeb.VehiculesLive do
  use WawShowcaseWeb, :live_view
  
  import Phoenix.Component

  @vehicules_per_page 10

  @impl true
  def mount(_params, _session, socket) do
    vehicules = generate_sample_vehicules()
    paginated = paginated_vehicules(vehicules, 1)
    total = total_pages(length(vehicules))
    
    {:ok,
     socket
     |> assign(:vehicules, vehicules)
     |> assign(:filtered_vehicules, vehicules)
     |> assign(:paginated_vehicules, paginated)
     |> assign(:total_pages, total)
     |> assign(:search_query, "")
     |> assign(:current_page, 1)
     |> assign(:show_form, false)
     |> assign(:form_step, 1)
     |> assign(:form_data, %{
       marque: "",
       modele: "",
       annee: nil,
       plaque: "",
       kilometrage: nil,
       niveau_carburant: ""
     })}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_form, !socket.assigns.show_form)
     |> assign(:form_step, 1)}
  end

  @impl true
  def handle_event("search", %{"search" => query}, socket) do
    filtered = filter_vehicules(socket.assigns.vehicules, query)
    paginated = paginated_vehicules(filtered, 1)
    total = total_pages(length(filtered))
    
    {:noreply,
     socket
     |> assign(:filtered_vehicules, filtered)
     |> assign(:paginated_vehicules, paginated)
     |> assign(:total_pages, total)
     |> assign(:search_query, query)
     |> assign(:current_page, 1)}
  end

  @impl true
  def handle_event("next_step", _params, socket) do
    next_step = min(socket.assigns.form_step + 1, 4)
    {:noreply, assign(socket, :form_step, next_step)}
  end

  @impl true
  def handle_event("previous_step", _params, socket) do
    prev_step = max(socket.assigns.form_step - 1, 1)
    {:noreply, assign(socket, :form_step, prev_step)}
  end

  @impl true
  def handle_event("update_form", params, socket) do
    form_data = Map.merge(socket.assigns.form_data, params)
    {:noreply, assign(socket, :form_data, form_data)}
  end

  @impl true
  def handle_event("save_vehicule", _params, socket) do
    # Ici on pourrait sauvegarder le véhicule
    # Pour l'instant, on ferme juste le formulaire
    {:noreply,
     socket
     |> assign(:show_form, false)
     |> assign(:form_step, 1)
     |> assign(:form_data, %{
       marque: "",
       modele: "",
       annee: nil,
       plaque: "",
       kilometrage: nil,
       niveau_carburant: ""
     })}
  end

  @impl true
  def handle_event("change_page", %{"page" => page}, socket) do
    new_page = String.to_integer(page)
    paginated = paginated_vehicules(socket.assigns.filtered_vehicules, new_page)
    
    {:noreply,
     socket
     |> assign(:current_page, new_page)
     |> assign(:paginated_vehicules, paginated)}
  end

  defp generate_sample_vehicules do
    [
      %{nom: "Voiture 1", plaque: "AB-123-CD", kilometrage: 45000},
      %{nom: "Voiture 2", plaque: "EF-456-GH", kilometrage: 32000},
      %{nom: "Camion 1", plaque: "IJ-789-KL", kilometrage: 125000},
      %{nom: "Voiture 3", plaque: "MN-012-OP", kilometrage: 28000},
      %{nom: "Camion 2", plaque: "QR-345-ST", kilometrage: 98000},
      %{nom: "Voiture 4", plaque: "UV-678-WX", kilometrage: 15000},
      %{nom: "Voiture 5", plaque: "YZ-901-AB", kilometrage: 67000},
      %{nom: "Camion 3", plaque: "CD-234-EF", kilometrage: 156000},
      %{nom: "Voiture 6", plaque: "GH-567-IJ", kilometrage: 42000},
      %{nom: "Voiture 7", plaque: "KL-890-MN", kilometrage: 23000},
      %{nom: "Camion 4", plaque: "OP-123-QR", kilometrage: 189000},
      %{nom: "Voiture 8", plaque: "ST-456-UV", kilometrage: 54000},
      %{nom: "Voiture 9", plaque: "WX-789-YZ", kilometrage: 31000},
      %{nom: "Camion 5", plaque: "AB-012-CD", kilometrage: 201000},
      %{nom: "Voiture 10", plaque: "EF-345-GH", kilometrage: 19000}
    ]
  end

  defp filter_vehicules(vehicules, query) when query == "" or query == nil do
    vehicules
  end

  defp filter_vehicules(vehicules, query) do
    query_lower = String.downcase(query)
    
    Enum.filter(vehicules, fn v ->
      String.contains?(String.downcase(v.nom), query_lower) or
        String.contains?(String.downcase(v.plaque), query_lower)
    end)
  end

  defp paginated_vehicules(vehicules, page) do
    start_index = (page - 1) * @vehicules_per_page
    Enum.slice(vehicules, start_index, @vehicules_per_page)
  end

  defp total_pages(count) when count <= 0, do: 1
  defp total_pages(count), do: ceil(count / @vehicules_per_page)

  defp render_table_rows(vehicules) do
    for vehicule <- vehicules do
      assigns = %{vehicule: vehicule}
      
      ~H"""
      <:tr state="normal">
        <.waw_td>
          <.waw_li>
            {@vehicule.nom}
          </.waw_li>
        </.waw_td>
        <.waw_td>
          <.waw_text value={@vehicule.plaque} />
        </.waw_td>
        <.waw_td>
          <.waw_distance unit={:kilometer} value={@vehicule.kilometrage} />
        </.waw_td>
      </:tr>
      """
    end
  end
end


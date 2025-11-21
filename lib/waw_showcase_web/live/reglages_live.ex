defmodule WawShowcaseWeb.ReglagesLive do
  use WawShowcaseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:form_data, %{
       nom: "",
       email: "",
       telephone: "",
       email_notifications: true,
       alertes_carburant: true,
       alertes_maintenance: true,
       rapports_quotidiens: false,
       theme: "auto",
       langue: "fr",
       deux_facteurs: true,
       delai_expiration: 30,
       cle_api: ""
     })
     |> assign(:accordions, %{
       profil: false,
       notifications: false,
       affichage: false,
       confidentialite: false
     })}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_form", params, socket) do
    # Normaliser les valeurs des checkboxes
    normalized_params =
      params
      |> normalize_checkbox("email_notifications")
      |> normalize_checkbox("alertes_carburant")
      |> normalize_checkbox("alertes_maintenance")
      |> normalize_checkbox("rapports_quotidiens")
      |> normalize_checkbox("deux_facteurs")
      |> normalize_number("delai_expiration")

    form_data = Map.merge(socket.assigns.form_data, normalized_params)
    {:noreply, assign(socket, :form_data, form_data)}
  end

  @impl true
  def handle_event("toggle_accordion", %{"id" => id}, socket) do
    accordions = Map.update!(socket.assigns.accordions, String.to_atom(id), &(!&1))
    {:noreply, assign(socket, :accordions, accordions)}
  end

  defp normalize_checkbox(params, key) do
    case Map.get(params, key) do
      "true" -> Map.put(params, key, true)
      "false" -> Map.put(params, key, false)
      true -> params
      false -> params
      _ -> Map.put(params, key, false)
    end
  end

  defp normalize_number(params, key) do
    case Map.get(params, key) do
      nil -> params
      "" -> params
      value when is_binary(value) ->
        case Integer.parse(value) do
          {int, _} -> Map.put(params, key, int)
          :error -> params
        end
      _ -> params
    end
  end
end

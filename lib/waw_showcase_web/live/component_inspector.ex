defmodule WawShowcaseWeb.Live.ComponentInspector do
  @moduledoc """
  Module helper pour gérer l'inspection des composants via clic droit.
  À utiliser dans tous les LiveViews.
  """

  defmacro __using__(_opts) do
    quote do
      @impl true
      def handle_event("inspect_component", params, socket) do
        # Coordonnées pour positionner le menu
        x =
          case Map.get(params, "x") || Map.get(params, "phx-value-x") do
            nil -> 0
            val when is_binary(val) -> String.to_integer(val)
            val -> val
          end

        y =
          case Map.get(params, "y") || Map.get(params, "phx-value-y") do
            nil -> 0
            val when is_binary(val) -> String.to_integer(val)
            val -> val
          end

        # Identifiant explicite du composant (data-component)
        component_key =
          Map.get(params, "component") ||
            Map.get(params, "phx-value-component") ||
            ""

        component =
          case String.trim(component_key) do
            "" ->
              nil

            key ->
              WawShowcase.ComponentFinder.find_component_by_key(key)
          end

        # Retourner les informations du composant au client
        component_data =
          if component do
            %{
              nom: component["Nom du composant"],
              type: component["Type"],
              sous_categorie: component["Sous catégorie"],
              code_source: component["Code source"]
            }
          else
            nil
          end

        # Envoyer un événement JavaScript avec les données du composant
        socket =
          push_event(socket, "component_inspected", %{
            component: component_data,
            x: x,
            y: y
          })

        {:noreply, socket}
      end

    end
  end
end

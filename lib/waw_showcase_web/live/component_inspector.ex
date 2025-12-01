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

        # Pour les inputs, récupérer le type
        # Phoenix convertit les tirets en underscores dans phx-value-*, donc phx-value-input-type devient input_type
        # Mais vérifier aussi les variantes possibles
        input_type =
          Map.get(params, "input_type") ||
            Map.get(params, "input-type") ||
            Map.get(params, "phx-value-input-type") ||
            Map.get(params, "phx-value-input_type")

        # Debug: logger le type trouvé pour les inputs
        if component_key == "input" do
          require Logger
          Logger.debug("Input type detection - params keys: #{inspect(Map.keys(params))}, found: #{inspect(input_type)}")
        end

        component =
          case String.trim(component_key) do
            "" ->
              nil

            key ->
              WawShowcase.ComponentCache.find_by_tag(key, input_type: input_type)
          end

        # Retourner les informations du composant au client
        component_data =
          if component do
            %{
              nom: component.nom,
              code_source: component.code_source,
              module: component.module,
              tag: component.tag
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

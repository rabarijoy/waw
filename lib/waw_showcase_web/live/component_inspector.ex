defmodule WawShowcaseWeb.Live.ComponentInspector do
  @moduledoc """
  Module helper pour gérer l'inspection des composants via clic droit.
  À utiliser dans tous les LiveViews.
  """

  defmacro __using__(_opts) do
    quote do
      @impl true
      def handle_event("inspect_component", %{"tag" => tag, "attributes" => attributes, "dom_path" => dom_path, "x" => x, "y" => y}, socket) do
        # Convertir le chemin DOM
        dom_path_list = 
          dom_path
          |> Enum.map(fn %{"tag" => t, "attributes" => a} ->
            attrs = 
              case a do
                map when is_map(map) -> map
                list when is_list(list) -> 
                  Enum.map(list, fn {k, v} -> {k, v} end) |> Map.new()
                _ -> %{}
              end
            {t, attrs}
          end)

        # Chercher le composant
        component = WawShowcase.ComponentFinder.find_component_by_dom_path(dom_path_list)

        # Retourner les informations du composant au client
        component_data = if component do
          %{
            nom: component["Nom du composant"],
            type: component["Type"],
            sous_categorie: component["Sous catégorie"],
            code_source: component["Code source"]
          }
        else
          nil
        end

        {:reply, %{component: component_data, x: x, y: y}, socket}
      end

      def handle_event("inspect_component", _params, socket) do
        {:noreply, socket}
      end
    end
  end
end


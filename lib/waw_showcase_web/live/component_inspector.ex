defmodule WawShowcaseWeb.Live.ComponentInspector do
  @moduledoc """
  Module helper pour gérer l'inspection des composants via clic droit.
  À utiliser dans tous les LiveViews.
  """

  defmacro __using__(_opts) do
    quote do
      @impl true
      def handle_event("inspect_component", %{"tag" => tag, "attributes" => attributes, "dom_path" => dom_path}, socket) do
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

        # Log pour debug (sera visible dans la console serveur)
        if component do
          IO.puts("""
          ========================================
          Composant identifié:
          Nom: #{component["Nom du composant"]}
          Type: #{component["Type"]}
          Sous catégorie: #{component["Sous catégorie"]}
          ========================================
          """)
        else
          IO.puts("Aucun composant trouvé pour: #{tag}")
        end

        {:noreply, socket}
      end

      def handle_event("inspect_component", _params, socket) do
        {:noreply, socket}
      end
    end
  end
end


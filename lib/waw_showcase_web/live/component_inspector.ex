defmodule WawShowcaseWeb.Live.ComponentInspector do
  @moduledoc """
  Module helper pour gérer l'inspection des composants via clic droit.
  À utiliser dans tous les LiveViews.
  """

  defmacro __using__(_opts) do
    quote do
      @impl true
      def handle_event("inspect_component", params, socket) do
        IO.puts("🔍 [DEBUG] handle_event inspect_component appelé avec params: #{inspect(Map.keys(params))}")

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
              IO.puts("⚠️  Aucun data-component fourni, composant non identifié")
              nil

            key ->
              IO.puts("✓ Recherche via data-component='#{key}'")
              WawShowcase.ComponentFinder.find_component_by_key(key)
          end

        # Log pour debug
        IO.puts("""
        ========================================
        Recherche de composant (mode data-component):
        LiveView: #{__MODULE__}
        data-component: #{inspect(component_key)}
        Composant trouvé: #{if component, do: component["Nom du composant"], else: "Aucun"}
        ========================================
        """)

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

        IO.puts("📤 Envoi de l'événement component_inspected avec: #{if component_data, do: component_data.nom, else: "nil"}")

        # Envoyer un événement JavaScript avec les données du composant
        socket =
          socket
          |> push_event("component_inspected", %{
            component: component_data,
            x: x,
            y: y
          })

        {:noreply, socket}
      end

      # Fonction helper pour obtenir le chemin du fichier HEEx
      defp get_heex_file_path(module) do
        # Convertir le nom du module en chemin de fichier HEEx.
        #
        # Exemple simples :
        #   WawShowcaseWeb.HomeLive
        #     -> segments après "WawShowcaseWeb" : ["HomeLive"]
        #     -> chemin HEEx        : lib/waw_showcase_web/live/home_live.html.heex
        #
        #   WawShowcaseWeb.Admin.UserLive
        #     -> segments après "WawShowcaseWeb" : ["Admin", "UserLive"]
        #     -> chemin HEEx        : lib/waw_showcase_web/live/admin/user_live.html.heex
        #
        # On insère systématiquement "live" comme premier segment sous app_web,
        # car c'est la convention Phoenix pour les LiveViews.

        module_string =
          case module do
            atom when is_atom(atom) -> Atom.to_string(atom)
            string when is_binary(string) -> string
            _ -> ""
          end

        segments =
          module_string
          |> String.replace("Elixir.", "")
          |> String.split(".")
          |> Enum.drop(1) # enlever "WawShowcaseWeb"

        underscored = Enum.map(segments, &Macro.underscore/1)

        # Insérer "live" devant les segments du module (home_live, admin/user_live, etc.)
        path =
          ["live" | underscored]
          |> Path.join()

        heex_path = Path.join(["lib", "waw_showcase_web", path <> ".html.heex"])
        full_path = Path.join([File.cwd!(), heex_path])

        if File.exists?(full_path) do
          full_path
        else
          IO.puts("⚠️  Fichier HEEx introuvable pour #{module}: #{full_path}")
          nil
        end
      end
    end
  end
end

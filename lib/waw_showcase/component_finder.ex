defmodule WawShowcase.ComponentFinder do
  @moduledoc """
  Recherche de composants dans `composants.json` à partir d'une clé explicite
  (valeur de l'attribut `data-component` envoyée par le front).
  """

  @doc """
  Charge la liste des composants depuis `composants.json`.

  Ordre de recherche :
    * racine du projet : `composants.json`
    * fallback : `priv/static/composants.json` de l'application
  """
  def load_components do
    root_file = Path.join([File.cwd!(), "composants.json"])

    case File.read(root_file) do
      {:ok, content} ->
        Jason.decode!(content)

      {:error, _} ->
        priv_file =
          Path.join([Application.app_dir(:waw_showcase, "priv"), "static", "composants.json"])

        case File.read(priv_file) do
          {:ok, content} -> Jason.decode!(content)
          {:error, _reason} -> []
        end
    end
  end

  @doc """
  Recherche directe par identifiant explicite (`data-component`).

  Modes supportés :

    * `data-component == "Nom du composant"` (prioritaire)
    * `data-component == base du tag` (ex: `"waw_stat"` pour `".waw_stat"`)
  """
  def find_component_by_key(component_key, components \\ nil) do
    components = components || load_components()
    base = component_key |> to_string() |> String.trim()

    if base == "" do
      nil
    else
      by_name =
        Enum.filter(components, fn comp ->
          (comp["Nom du composant"] || "") == base
        end)

      case by_name do
        [] ->
          variants = [base, ".#{base}"]

          by_tag =
            Enum.filter(components, fn comp ->
              tag = comp["tag"] || ""
              tag in variants
            end)

          case by_tag do
            [] -> nil
            [single] -> single
            multiple -> Enum.min_by(multiple, & &1["Nom du composant"])
          end

        [single] ->
          single

        multiple ->
          Enum.min_by(multiple, & &1["Nom du composant"])
      end
    end
  end
end





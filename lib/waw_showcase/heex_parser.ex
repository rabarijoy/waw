defmodule WawShowcase.HeexParser do
  @moduledoc """
  Module pour parser les fichiers HEEx et identifier les composants Waw.
  """

  def parse_heex_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        extract_components(content)
      {:error, _} ->
        []
    end
  end

  defp extract_components(content) do
    # Extraire tous les composants Waw du fichier HEEx
    # Pattern pour trouver les composants HEEx: <.waw_* ...>
    Regex.scan(~r/<\.(waw_[\w-]+)([^>]*?)(?:\/>|>)/s, content)
    |> Enum.map(fn [full_match, component_name, attributes_string] ->
      %{
        component_name: component_name,
        full_match: full_match,
        attributes: parse_attributes(attributes_string),
        position: :binary.match(content, full_match)
      }
    end)
  end

  defp parse_attributes(attrs_string) do
    # Parser les attributs d'un composant HEEx
    Regex.scan(~r/(\w+)\s*=\s*{([^}]+)}|(\w+)\s*=\s*"([^"]+)"|(\w+)\s*=\s*'([^']+)'|(\w+)\s*=\s*([^\s>]+)/, attrs_string)
    |> Enum.map(fn
      [_, key, value, "", "", "", "", ""] -> {key, value}
      [_, "", "", key, value, "", ""] -> {key, value}
      [_, "", "", "", "", key, value] -> {key, value}
      [_, "", "", "", "", "", "", key, value] -> {key, value}
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end

  def find_component_in_heex(heex_content, dom_path) do
    # Trouver le composant HEEx correspondant au chemin DOM
    # On cherche en remontant le chemin DOM pour trouver le composant parent
    components = extract_components(heex_content)

    # Pour chaque élément du chemin DOM, essayer de trouver un composant correspondant
    Enum.reduce_while(dom_path, nil, fn {_tag, _attrs}, _acc ->
      # Chercher dans les composants extraits
      case find_matching_component(components, dom_path) do
        nil -> {:cont, nil}
        component -> {:halt, component}
      end
    end)
  end

  defp find_matching_component(components, _dom_path) do
    # Pour l'instant, retourner le premier composant trouvé
    # TODO: Améliorer la logique de correspondance
    List.first(components)
  end
end

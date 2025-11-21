defmodule WawShowcase.ComponentFinder do
  @moduledoc """
  Module pour trouver les composants correspondants dans composants.json
  basé sur l'analyse du DOM.
  """

  @components_file Path.join([Application.app_dir(:waw_showcase, "priv"), "static", "composants.json"])

  def load_components do
    case File.read(@components_file) do
      {:ok, content} ->
        Jason.decode!(content)
      {:error, _} ->
        # Fallback: chercher dans le répertoire du projet
        project_file = Path.join([File.cwd!(), "composants.json"])
        case File.read(project_file) do
          {:ok, content} -> Jason.decode!(content)
          {:error, _} -> []
        end
    end
  end

  def find_component(tag, attributes, components \\ nil) do
    components = components || load_components()

    # Étape a: Chercher les composants avec la même balise ouvrante
    candidates = find_by_tag(tag, components)

    if Enum.empty?(candidates) do
      nil
    else
      # Étape c: Filtrer par attributs
      filtered = filter_by_attributes(candidates, attributes)

      # Étape d: Comparer les valeurs des attributs
      matched = match_attribute_values(filtered, attributes)

      # Étape e: Résolution finale (premier par ordre alphabétique)
      case matched do
        [] -> List.first(filtered)
        list -> List.first(Enum.sort_by(list, & &1["Nom du composant"]))
      end
    end
  end

  defp find_by_tag(tag, components) do
    Enum.filter(components, fn component ->
      code_source = component["Code source"] || ""
      # Extraire la première balise ouvrante
      case Regex.run(~r/<([\w-]+)/, code_source) do
        [_, extracted_tag] ->
          normalize_tag(extracted_tag) == normalize_tag(tag)
        _ -> false
      end
    end)
  end

  defp normalize_tag(tag) do
    tag
    |> String.downcase()
    |> String.replace("_", "-")
  end

  defp filter_by_attributes(candidates, dom_attributes) do
    Enum.filter(candidates, fn component ->
      code_source = component["Code source"] || ""
      component_attrs = extract_attributes(code_source)

      # Vérifier que tous les attributs du composant sont présents dans le DOM
      Enum.all?(component_attrs, fn {key, _value} ->
        Map.has_key?(dom_attributes, key) || Map.has_key?(dom_attributes, "data-#{key}")
      end)
    end)
  end

  defp match_attribute_values(candidates, dom_attributes) do
    Enum.filter(candidates, fn component ->
      code_source = component["Code source"] || ""
      component_attrs = extract_attributes(code_source)

      # Comparer les valeurs exactes des attributs
      Enum.all?(component_attrs, fn {key, value} ->
        dom_value = Map.get(dom_attributes, key) || Map.get(dom_attributes, "data-#{key}")

        case dom_value do
          nil -> false
          val when is_binary(val) -> normalize_value(val) == normalize_value(value)
          val -> to_string(val) == normalize_value(value)
        end
      end)
    end)
  end

  defp extract_attributes(code_source) do
    # Extraire les attributs de la première balise
    case Regex.run(~r/<[\w-]+\s+([^>]+)>/, code_source) do
      [_, attrs_string] ->
        attrs_string
        |> String.split(~r/\s+(?=\w+=)/)
        |> Enum.map(&parse_attribute/1)
        |> Enum.reject(&is_nil/1)
        |> Map.new()
      _ -> %{}
    end
  end

  defp parse_attribute(attr_string) do
    case Regex.run(~r/([\w-]+)=["']([^"']+)["']/, attr_string) do
      [_, key, value] -> {normalize_attr_key(key), value}
      _ -> nil
    end
  end

  defp normalize_attr_key(key) do
    key
    |> String.replace("_", "-")
    |> String.downcase()
  end

  defp normalize_value(value) do
    value
    |> String.trim()
    |> String.downcase()
  end

  def find_component_by_dom_path(dom_path, components \\ nil) do
    components = components || load_components()

    # Convertir les attributs de string keys en atom keys si nécessaire
    normalized_path =
      Enum.map(dom_path, fn {tag, attrs} ->
        normalized_attrs =
          attrs
          |> Enum.map(fn
            {k, v} when is_binary(k) -> {String.to_atom(k), v}
            {k, v} -> {k, v}
          end)
          |> Map.new()
        {tag, normalized_attrs}
      end)

    # Parcourir le chemin DOM de bas en haut
    Enum.reduce_while(normalized_path, nil, fn {tag, attributes}, _acc ->
      # Convertir les attributs en string keys pour la recherche
      string_key_attrs =
        attributes
        |> Enum.map(fn {k, v} -> {to_string(k), v} end)
        |> Map.new()

      case find_component(tag, string_key_attrs, components) do
        nil -> {:cont, nil}
        component -> {:halt, component}
      end
    end)
  end
end

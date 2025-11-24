defmodule Mix.Tasks.EnrichComposants do
  @moduledoc """
  Enrichit le fichier composants.json avec les colonnes 'tag' et 'attributs'
  extraites du 'Code source'.
  """
  use Mix.Task

  @shortdoc "Enrichit composants.json avec tag et attributs"

  def run(_args) do
    Mix.Task.run("app.start")

    json_file = Path.join([File.cwd!(), "composants.json"])

    case File.read(json_file) do
      {:ok, content} ->
        IO.puts("📖 Lecture de #{json_file}...")
        components = Jason.decode!(content)

        IO.puts("🔄 Enrichissement de #{length(components)} composants...")

        enriched =
          Enum.map(components, fn comp ->
            code_source = comp["Code source"] || ""

            # Extraire la balise d'ouverture
            opening_tag = extract_opening_tag(code_source)

            # Extraire le tag exact
            exact_tag = extract_exact_tag_from_opening(opening_tag)

            # Extraire les attributs dans l'ordre
            ordered_attrs = extract_ordered_attributes_from_opening(opening_tag)

            # Ajouter les nouvelles colonnes
            comp
            |> Map.put("tag", exact_tag)
            |> Map.put("attributs", ordered_attrs)
          end)

        # Sauvegarder le JSON enrichi
        json_content = Jason.encode!(enriched, pretty: true)
        File.write!(json_file, json_content)

        IO.puts("✅ Fichier enrichi sauvegardé dans #{json_file}")
        IO.puts("📊 Statistiques:")
        IO.puts("   - Composants traités: #{length(enriched)}")
        IO.puts("   - Composants avec tag: #{Enum.count(enriched, fn c -> c["tag"] != "" end)}")
        IO.puts("   - Composants avec attributs: #{Enum.count(enriched, fn c -> length(c["attributs"]) > 0 end)}")

      {:error, reason} ->
        IO.puts("❌ Erreur lors de la lecture de #{json_file}: #{inspect(reason)}")
    end
  end

  # Extraire la balise d'ouverture complète (entre < et > ou />)
  defp extract_opening_tag(code_source) do
    # Chercher la première balise d'ouverture complète
    case Regex.run(~r/<[^>]+(?:>|\/>)/, code_source) do
      [tag] -> tag
      _ -> ""
    end
  end

  # Extraire le tag exact depuis la balise d'ouverture (entre < et le premier espace)
  defp extract_exact_tag_from_opening(opening_tag) do
    case Regex.run(~r/<([^\s>]+)/, opening_tag) do
      [_, tag] -> tag
      _ -> ""
    end
  end

  # Extraire les attributs dans l'ordre depuis la balise d'ouverture (noms seulement, avant le =)
  defp extract_ordered_attributes_from_opening(opening_tag) do
    # Extraire la partie après le tag (entre le premier espace et >)
    case Regex.run(~r/<[^\s>]+\s+([^>]+)/, opening_tag) do
      [_, attrs_string] ->
        # Extraire tous les noms d'attributs dans l'ordre (pattern: attrName=)
        # Utiliser \b pour les bornes de mot et capturer uniquement le nom avant le =
        Regex.scan(~r/\b(\w+)\s*=/, attrs_string)
        |> Enum.map(fn [_, key] -> key end)
      _ -> []
    end
  end
end

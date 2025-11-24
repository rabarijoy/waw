defmodule WawShowcase.ComponentFinder do
  @moduledoc """
  Module pour trouver les composants correspondants dans composants.json
  basé sur l'analyse du DOM.
  """

  def load_components do
    # Essayer d'abord à la racine du projet (pour le développement)
    root_file = Path.join([File.cwd!(), "composants.json"])

    case File.read(root_file) do
      {:ok, content} ->
        IO.puts("✓ Loaded composants.json from: #{root_file} (#{byte_size(content)} bytes)")
        Jason.decode!(content)
      {:error, _} ->
        # Fallback: essayer dans priv/static
        priv_file = Path.join([Application.app_dir(:waw_showcase, "priv"), "static", "composants.json"])
        case File.read(priv_file) do
          {:ok, content} ->
            IO.puts("✓ Loaded composants.json from: #{priv_file} (#{byte_size(content)} bytes)")
            Jason.decode!(content)
          {:error, reason} ->
            IO.puts("✗ ERROR: Cannot load composants.json from any location. Last error: #{inspect(reason)}")
            IO.puts("  Tried: #{root_file}")
            IO.puts("  Tried: #{priv_file}")
            []
        end
    end
  end

  # Recherche directe par identifiant explicite (data-component)
  # Exemple : data-component="waw_stat" → on cherche les entrées dont le tag est ".waw_stat" ou "waw_stat"
  def find_component_by_key(component_key, components \\ nil) do
    components = components || load_components()

    base = String.trim(to_string(component_key))

    if base == "" do
      nil
    else
      variants = [base, ".#{base}"]

      candidates =
        Enum.filter(components, fn comp ->
          tag = comp["tag"] || ""
          tag in variants
        end)

      case candidates do
        [] ->
          IO.puts("⚠️  Aucun composant trouvé pour data-component='#{base}'")
          nil

        [single] ->
          single

        multiple ->
          IO.puts("📝 Plusieurs composants pour data-component='#{base}', tri par nom")
          Enum.min_by(multiple, & &1["Nom du composant"])
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
    normalized_tag = normalize_tag(tag)

    Enum.filter(components, fn component ->
      code_source = component["Code source"] || ""
      # Nettoyer le code source pour faciliter la recherche
      cleaned_code =
        code_source
        |> String.replace(~r/\n/, " ")
        |> String.replace(~r/\s+/, " ")
        |> String.trim()

      # Extraire le nom du composant HEEx (ex: <.waw_stat> -> waw_stat)
      component_name =
        case Regex.run(~r/<\.([\w-]+)(?:\s|>|\/)/, cleaned_code) do
          [_, name] -> normalize_tag(name)
          _ -> nil
        end

      # Pour les composants HEEx, ils sont transformés en div/span/etc dans le DOM
      # On accepte tous les composants Waw si le tag du DOM est div/span/section/etc
      # car on ne peut pas les distinguer par le tag seul
      case normalized_tag do
        "div" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "span" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "section" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "article" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "header" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "footer" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "main" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        "nav" -> component_name != nil && String.starts_with?(component_name || "", "waw")
        _ ->
          # Pour les autres tags, on cherche une correspondance exacte
          # (mais c'est rare car les composants Waw sont généralement transformés en div/span)
          component_name == normalized_tag
      end
    end)
  end

  defp normalize_tag(tag) do
    tag
    |> String.downcase()
    |> String.replace("_", "-")
  end

  defp filter_by_attributes(candidates, dom_attributes) do
    # Si le composant n'a pas d'attributs, il correspond à tout
    if Enum.empty?(dom_attributes) do
      candidates
    else
      Enum.filter(candidates, fn component ->
        code_source = component["Code source"] || ""
        component_attrs = extract_attributes(code_source)

        # Si le composant n'a pas d'attributs requis, il correspond
        if Enum.empty?(component_attrs) do
          true
        else
          # Vérifier que tous les attributs du composant sont présents dans le DOM
          # On est plus flexible : au moins un attribut doit correspondre
          # (car les composants HEEx peuvent avoir des attributs transformés)
          matches =
            component_attrs
            |> Enum.count(fn {key, _value} ->
              normalized_key = normalize_attr_key(key)
              Map.has_key?(dom_attributes, normalized_key) ||
              Map.has_key?(dom_attributes, key) ||
              Map.has_key?(dom_attributes, "data-#{normalized_key}") ||
              Map.has_key?(dom_attributes, "data-#{key}") ||
              # Chercher aussi dans les classes CSS
              (Map.has_key?(dom_attributes, "class") &&
               String.contains?(Map.get(dom_attributes, "class", ""), normalized_key))
            end)

          # Au moins 50% des attributs doivent correspondre
          # (pour être flexible avec les transformations HEEx)
          matches >= max(1, div(map_size(component_attrs), 2))
        end
      end)
    end
  end

  defp match_attribute_values(candidates, dom_attributes) do
    # Si aucun attribut dans le DOM, retourner tous les candidats
    if Enum.empty?(dom_attributes) do
      candidates
    else
      Enum.filter(candidates, fn component ->
        code_source = component["Code source"] || ""
        component_attrs = extract_attributes(code_source)

        # Si le composant n'a pas d'attributs, il correspond
        if Enum.empty?(component_attrs) do
          true
        else
          # Comparer les valeurs exactes des attributs
          Enum.all?(component_attrs, fn {key, value} ->
            normalized_key = normalize_attr_key(key)
            dom_value =
              Map.get(dom_attributes, normalized_key) ||
              Map.get(dom_attributes, key) ||
              Map.get(dom_attributes, "data-#{normalized_key}") ||
              Map.get(dom_attributes, "data-#{key}")

            case dom_value do
              nil -> false
              val when is_binary(val) -> normalize_value(val) == normalize_value(value)
              val -> to_string(val) == normalize_value(value)
            end
          end)
        end
      end)
    end
  end

  defp extract_attributes(code_source) do
    # Nettoyer le code source (enlever les retours à la ligne et espaces multiples)
    cleaned_code =
      code_source
      |> String.replace(~r/\n/, " ")
      |> String.replace(~r/\s+/, " ")
      |> String.trim()

    # Extraire les attributs de la première balise
    # Pattern amélioré pour capturer les attributs même avec des valeurs entre guillemets contenant des espaces
    case Regex.run(~r/<[\w-]+\s+([^>]+)>/, cleaned_code) do
      [_, attrs_string] ->
        # Parser les attributs en gérant les guillemets simples et doubles
        attrs_string
        |> String.split(~r/\s+(?=\w+\s*=)/)
        |> Enum.map(&parse_attribute/1)
        |> Enum.reject(&is_nil/1)
        |> Map.new()
      _ ->
        # Si pas d'attributs, vérifier si c'est une balise auto-fermante avec attributs
        case Regex.run(~r/<([\w-]+)\s+([^\/>]+)\s*\/>/, cleaned_code) do
          [_, _tag, attrs_string] ->
            attrs_string
            |> String.split(~r/\s+(?=\w+\s*=)/)
            |> Enum.map(&parse_attribute/1)
            |> Enum.reject(&is_nil/1)
            |> Map.new()
          _ -> %{}
        end
    end
  end

  defp parse_attribute(attr_string) do
    # Pattern amélioré pour gérer les guillemets simples, doubles, et les valeurs sans guillemets
    cond do
      # Attribut avec guillemets doubles
      Regex.match?(~r/^[\w-]+="[^"]*"$/, attr_string) ->
        case Regex.run(~r/([\w-]+)="([^"]*)"/, attr_string) do
          [_, key, value] -> {normalize_attr_key(key), value}
          _ -> nil
        end
      # Attribut avec guillemets simples
      Regex.match?(~r/^[\w-]+='[^']*'$/, attr_string) ->
        case Regex.run(~r/([\w-]+)='([^']*)'/, attr_string) do
          [_, key, value] -> {normalize_attr_key(key), value}
          _ -> nil
        end
      # Attribut sans guillemets (valeur simple)
      Regex.match?(~r/^[\w-]+=[\w-]+$/, attr_string) ->
        case Regex.run(~r/([\w-]+)=([\w-]+)/, attr_string) do
          [_, key, value] -> {normalize_attr_key(key), value}
          _ -> nil
        end
      # Pattern par défaut (plus flexible)
      true ->
        case Regex.run(~r/([\w-]+)=["']?([^"'\s>]+)["']?/, attr_string) do
          [_, key, value] -> {normalize_attr_key(key), value}
          _ -> nil
        end
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

  # Chercher un composant en partant directement d'une ligne HEEx (data-phx-loc)
  # 1. Lire le fichier HEEx
  # 2. Chercher la balise <.waw_...> la plus proche de cette ligne
  # 3. Extraire la balise d'ouverture complète
  # 4. Appliquer la logique stricte tag + attributs contre composants.json
  def find_component_from_loc(heex_file_path, line_loc, components \\ nil) do
    components = components || load_components()

    IO.puts("🔎 Recherche composant à partir de loc=#{line_loc} dans #{heex_file_path}")

    case File.read(heex_file_path) do
      {:ok, heex_content} ->
        lines = String.split(heex_content, "\n", trim: false)
        total_lines = length(lines)

        # Clamp de la ligne dans les bornes du fichier
        line_loc =
          line_loc
          |> max(1)
          |> min(total_lines)

        case find_nearest_waw_call(lines, line_loc) do
          nil ->
            IO.puts("⚠️  Aucune balise <.waw_...> trouvée autour de la ligne #{line_loc}")
            nil

          {start_line, start_column} ->
            IO.puts("🔗 Balise <.waw_...> trouvée à la ligne #{start_line}, colonne #{start_column}")

            snippet =
              lines
              |> Enum.slice(start_line - 1, 30)
              |> Enum.join("\n")

            case Regex.run(~r/<\.(waw_[\w-]+)([^>]*?)(?:\/>|>)/s, snippet) do
              [full_match, component_name, attributes_string] ->
                heex_comp = %{
                  component_name: component_name,
                  full_match: full_match,
                  attributes: parse_heex_attributes(attributes_string),
                  position: {start_line, start_column}
                }

                find_component_by_exact_match(heex_comp, components)

              _ ->
                IO.puts("⚠️  Impossible d'extraire la balise HEEx complète autour de la ligne #{line_loc}")
                nil
            end
        end

      {:error, reason} ->
        IO.puts("⚠️  Erreur lecture fichier HEEx #{heex_file_path} pour loc=#{line_loc}: #{inspect(reason)}")
        nil
    end
  end

  # Trouver la ligne la plus proche contenant une balise <.waw_...>
  defp find_nearest_waw_call(lines, line_loc) do
    total_lines = length(lines)

    # D'abord chercher au-dessus (vers le début du fichier)
    up_match =
      line_loc
      |> Stream.iterate(&(&1 - 1))
      |> Stream.take_while(&(&1 >= 1))
      |> Enum.find_value(fn idx ->
        line = Enum.at(lines, idx - 1, "")

        case Regex.run(~r/<\.waw_/, line, return: :index) do
          [{col, _len}] -> {idx, col}
          _ -> nil
        end
      end)

    case up_match do
      nil ->
        # Sinon, chercher en dessous (vers la fin du fichier)
        down_match =
          line_loc
          |> Stream.iterate(&(&1 + 1))
          |> Stream.take_while(&(&1 <= total_lines))
          |> Enum.find_value(fn idx ->
            line = Enum.at(lines, idx - 1, "")

            case Regex.run(~r/<\.waw_/, line, return: :index) do
              [{col, _len}] -> {idx, col}
              _ -> nil
            end
          end)

        down_match

      match ->
        match
    end
  end

  def find_component_in_heex(heex_file_path, dom_path, components \\ nil) do
    components = components || load_components()

    # Lire le fichier HEEx
    case File.read(heex_file_path) do
      {:ok, heex_content} ->
        # Extraire tous les composants Waw du fichier HEEx
        heex_components = extract_heex_components(heex_content)

        IO.puts("📄 Composants HEEx trouvés dans #{Path.basename(heex_file_path)}: #{length(heex_components)}")
        Enum.each(heex_components, fn comp ->
          IO.puts("  - #{comp.component_name} avec #{map_size(comp.attributes)} attributs")
        end)

        # Chercher le composant correspondant au chemin DOM
        result = find_component_by_heex_match(heex_components, dom_path, components)

        if result do
          IO.puts("✅ Composant trouvé via HEEx: #{result["Nom du composant"]}")
        else
          IO.puts("❌ Aucun composant trouvé via HEEx")
        end

        result
      {:error, reason} ->
        IO.puts("⚠️  Erreur lecture fichier HEEx #{heex_file_path}: #{inspect(reason)}")
        IO.puts("⚠️  Aucun fallback DOM utilisé, retour nil (recherche strictement basée sur HEEx)")
        nil
    end
  end

  def find_component_by_dom_path(dom_path, components \\ nil) do
    components = components || load_components()

    # Le chemin DOM commence par l'élément cliqué et remonte vers le parent
    # Convertir les attributs de string keys en atom keys si nécessaire
    normalized_path =
      Enum.map(dom_path, fn
        {tag, attrs} when is_map(attrs) ->
          normalized_attrs =
            attrs
            |> Enum.map(fn
              {k, v} when is_binary(k) -> {String.to_atom(k), v}
              {k, v} -> {k, v}
            end)
            |> Map.new()
          {tag, normalized_attrs}
        %{"tag" => tag, "attributes" => attrs} ->
          normalized_attrs =
            attrs
            |> Enum.map(fn
              {k, v} when is_binary(k) -> {String.to_atom(k), v}
              {k, v} -> {k, v}
            end)
            |> Map.new()
          {tag, normalized_attrs}
        _ ->
          {"", %{}}
      end)

    # Parcourir le chemin DOM en commençant par l'élément cliqué (premier élément)
    # et remonter progressivement jusqu'à trouver un composant
    Enum.reduce_while(normalized_path, nil, fn {tag, attributes}, _acc ->
      # Convertir les attributs en string keys pour la recherche
      string_key_attrs =
        attributes
        |> Enum.map(fn {k, v} -> {to_string(k), v} end)
        |> Map.new()

      # Chercher un composant correspondant à ce tag et ces attributs
      # Si le tag est div/span/etc, on cherche aussi par attributs uniquement
      component =
        case find_component(tag, string_key_attrs, components) do
          nil ->
            # Si aucun composant trouvé par tag, essayer de chercher uniquement par attributs
            # (pour les composants HEEx transformés en div/span)
            if tag in ["div", "span", "section", "article", "header", "footer", "main", "nav"] do
              find_component_by_attributes_only(string_key_attrs, components)
            else
              nil
            end
          found -> found
        end

      case component do
        nil ->
          # Aucun composant trouvé à ce niveau, continuer avec le parent
          {:cont, nil}
        comp ->
          # Composant trouvé ! Arrêter la recherche
          {:halt, comp}
      end
    end)
  end

  # Chercher un composant uniquement par ses attributs (pour les composants HEEx transformés)
  defp find_component_by_attributes_only(dom_attributes, components) do
    # Filtrer les composants qui ont des attributs correspondants
    candidates =
      Enum.filter(components, fn component ->
        code_source = component["Code source"] || ""
        component_attrs = extract_attributes(code_source)

        # Vérifier si au moins un attribut correspond
        if Enum.empty?(component_attrs) do
          false
        else
          # Au moins 50% des attributs doivent correspondre
          matches =
            component_attrs
            |> Enum.count(fn {key, _value} ->
              normalized_key = normalize_attr_key(key)
              Map.has_key?(dom_attributes, normalized_key) ||
              Map.has_key?(dom_attributes, key) ||
              # Chercher aussi dans les classes CSS
              (Map.has_key?(dom_attributes, "class") &&
               String.contains?(Map.get(dom_attributes, "class", ""), normalized_key))
            end)

              matches >= max(1, div(map_size(component_attrs), 2))
        end
      end)

    # Retourner le premier candidat (ou trier par ordre alphabétique si plusieurs)
    case candidates do
      [] -> nil
      [single] -> single
      multiple -> List.first(Enum.sort_by(multiple, & &1["Nom du composant"]))
    end
  end

  # Extraire tous les composants Waw d'un fichier HEEx
  defp extract_heex_components(heex_content) do
    # Pattern pour trouver les composants HEEx: <.waw_* ...>
    # IMPORTANT: full_match doit contenir la balise complète avec le point initial
    Regex.scan(~r/<\.(waw_[\w-]+)([^>]*?)(?:\/>|>)/s, heex_content)
    |> Enum.map(fn [full_match, component_name, attributes_string] ->
      # S'assurer que full_match contient bien le tag complet avec le point
      # Si full_match ne commence pas par <., c'est qu'il y a un problème
      normalized_full_match =
        if String.starts_with?(full_match, "<.") do
          full_match
        else
          # Corriger si nécessaire
          "<.#{component_name}#{attributes_string}#{if String.contains?(full_match, "/>"), do: "/>", else: ">"}"
        end

      %{
        component_name: component_name,
        full_match: normalized_full_match,
        attributes: parse_heex_attributes(attributes_string),
        position: :binary.match(heex_content, full_match)
      }
    end)
  end

  # Parser les attributs d'un composant HEEx
  defp parse_heex_attributes(attrs_string) do
    # Parser les attributs HEEx (ex: value={251}, title="Véhicules", icon="car")
    Regex.scan(~r/(\w+)\s*=\s*{([^}]+)}|(\w+)\s*=\s*"([^"]+)"|(\w+)\s*=\s*'([^']+)'|(\w+)\s*=\s*([^\s>]+)/, attrs_string)
    |> Enum.map(fn
      [_, key, value, "", "", "", "", ""] -> {normalize_attr_key(key), value}
      [_, "", "", key, value, "", ""] -> {normalize_attr_key(key), value}
      [_, "", "", "", "", key, value] -> {normalize_attr_key(key), value}
      [_, "", "", "", "", "", "", key, value] -> {normalize_attr_key(key), value}
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end

  # Trouver le composant correspondant en comparant les composants HEEx avec composants.json.
  #
  # IMPORTANT :
  #  - On utilise le dom_path pour exclure les composants globalement présents
  #    (ex: <.waw_header> en haut de la page) lorsqu'on clique ailleurs.
  #  - On NE parcourt plus tous les composants HEEx en aveugle : on filtre d'abord
  #    les composants HEEx compatibles avec l'élément cliqué, puis on applique
  #    la logique stricte tag + attributs (find_component_by_exact_match/2).
  defp find_component_by_heex_match(heex_components, dom_path, components) do
    # Si aucun composant HEEx trouvé, retourner nil immédiatement
    if Enum.empty?(heex_components) do
      IO.puts("⚠️  Aucun composant HEEx trouvé dans le fichier")
      nil
    else
      # Ensemble des tags HTML présents dans le chemin DOM (div, header, footer, ...),
      # du plus profond (élément cliqué) au plus haut (parent proche du body).
      dom_tags =
        dom_path
        |> Enum.map(fn
          {tag, _attrs} when is_binary(tag) -> String.downcase(tag)
          %{"tag" => tag} when is_binary(tag) -> String.downcase(tag)
          _ -> ""
        end)
        |> Enum.reject(&(&1 == ""))
        |> MapSet.new()

      IO.puts("📋 Tags HTML présents dans le chemin DOM: #{inspect(MapSet.to_list(dom_tags))}")

      # Filtrer les composants HEEx qui sont incompatibles avec le chemin DOM.
      #
      # Exemple :
      #   - Si aucun tag 'header'/'nav' dans le dom_path, on exclut <.waw_header>
      #   - Si aucun tag 'footer' dans le dom_path, on exclut <.waw_footer>
      compatible_heex_components =
        Enum.filter(heex_components, fn comp ->
          comp_name = comp.component_name || ""

          cond do
            # Header Waw : ne le considérer que si on clique dans un header / nav
            String.starts_with?(comp_name, "waw_header") ->
              MapSet.member?(dom_tags, "header") or MapSet.member?(dom_tags, "nav")

            # Footer Waw : ne le considérer que si on clique dans un footer
            String.starts_with?(comp_name, "waw_footer") ->
              MapSet.member?(dom_tags, "footer")

            # Autres composants : pas de filtrage strict pour l'instant
            true ->
              true
          end
        end)

      IO.puts("📋 Composants HEEx compatibles après filtrage par dom_path (#{length(compatible_heex_components)}):")

      Enum.each(compatible_heex_components, fn comp ->
        opening = extract_opening_tag(comp.full_match || "")
        tag = extract_exact_tag_from_opening(opening)
        IO.puts("  - #{comp.component_name} → tag HEEx: '#{tag}'")
      end)

      # Si le filtrage enlève tout, on préfère renvoyer nil plutôt que tomber
      # sur un faux positif global (comme l'ancien comportement avec le header).
      if Enum.empty?(compatible_heex_components) do
        IO.puts("⚠️  Aucun composant HEEx compatible avec le chemin DOM")
        nil
      else
        # Tester uniquement les composants HEEx compatibles, en appliquant
        # la logique stricte tag + attributs contre composants.json.
        Enum.reduce_while(compatible_heex_components, nil, fn heex_comp, _acc ->
          IO.puts("🔍 Test du composant HEEx compatible: #{heex_comp.component_name}")
          result = find_component_by_exact_match(heex_comp, components)

          case result do
            nil ->
              IO.puts("  ❌ Aucune correspondance JSON pour #{heex_comp.component_name}")
              {:cont, nil}

            component ->
              IO.puts("  ✅ Composant trouvé via HEEx: #{heex_comp.component_name} → #{component["Nom du composant"]}")
              {:halt, component}
          end
        end)
      end
    end
  end

  # Trouver un composant dans composants.json en utilisant la logique structurée :
  # 1. Extraire le tag exact et les attributs du composant cliqué depuis le HEEx
  # 2. Filtrer par tag exact (utiliser la colonne 'tag' du JSON)
  # 3. Filtrer par attributs un par un dans l'ordre (utiliser la colonne 'attributs' du JSON)
  # 4. Si plusieurs résultats, trier alphabétiquement
  defp find_component_by_exact_match(heex_comp, components) do
    heex_full_match = heex_comp.full_match || ""

    IO.puts("")
    IO.puts("=" <> String.duplicate("=", 60))
    IO.puts("🔍 RECHERCHE COMPOSANT")
    IO.puts("=" <> String.duplicate("=", 60))
    IO.puts("📄 Code HEEx cliqué: #{String.slice(heex_full_match, 0, 100)}")

    # Étape 3: Extraire le tag et les attributs du composant cliqué
    opening_tag = extract_opening_tag(heex_full_match)

    if opening_tag == "" do
      IO.puts("❌ Impossible d'extraire la balise d'ouverture")
      nil
    else
      # Extraire le tag exact (clickedTag)
      clicked_tag = extract_exact_tag_from_opening(opening_tag)
      IO.puts("🏷️  Tag cliqué: '#{clicked_tag}'")

      # Extraire les attributs dans l'ordre (clickedAttributes)
      clicked_attributes = extract_ordered_attributes_from_opening(opening_tag)
      IO.puts("📝 Attributs cliqués (#{length(clicked_attributes)}): #{inspect(clicked_attributes)}")

      # Étape 4.1: Filtrer par tag exact
      candidates = filter_by_exact_tag_strict(components, clicked_tag)
      IO.puts("📋 Étape 1 - Candidats après filtrage par tag exact: #{length(candidates)}")

      if Enum.empty?(candidates) do
        IO.puts("❌ Aucun candidat trouvé pour le tag '#{clicked_tag}'")
        nil
      else
        # Étape 4.2: Filtrer par attributs un par un dans l'ordre
        final_candidates = filter_by_attributes_ordered_strict(candidates, clicked_attributes)
        IO.puts("✅ Étape 2 - Candidats après filtrage par attributs: #{length(final_candidates)}")

        # Étape 4.3: Résolution finale
        case final_candidates do
          [] ->
            IO.puts("⚠️  Tous les candidats ont été éliminés, retour aux candidats après tag")
            # Si tous les attributs ont éliminé tous les candidats, retourner les candidats après le tag
            candidates
          [single] ->
            IO.puts("🎉 Composant identifié: #{single["Nom du composant"]}")
            single
          multiple ->
            # Trier alphabétiquement et prendre le premier (seulement après avoir appliqué tous les attributs)
            IO.puts("📝 Étape 3 - Plusieurs candidats (#{length(multiple)}), tri alphabétique...")
            best = List.first(Enum.sort_by(multiple, & &1["Nom du composant"]))
            IO.puts("🎉 Composant identifié (parmi #{length(multiple)}): #{best["Nom du composant"]}")
            best
        end
      end
    end
  end

  # Extraire la balise d'ouverture complète (entre < et > ou />) - utilisé uniquement pour le composant cliqué
  defp extract_opening_tag(heex_full_match) do
    # Chercher la première balise d'ouverture complète
    case Regex.run(~r/<[^>]+(?:>|\/>)/, heex_full_match) do
      [tag] -> tag
      _ -> ""
    end
  end

  # Extraire le tag exact depuis la balise d'ouverture (entre < et le premier espace) - utilisé uniquement pour le composant cliqué
  defp extract_exact_tag_from_opening(opening_tag) do
    # Extraire tout le texte entre < et le premier espace ou >
    # Ne jamais tronquer, garder le tag complet avec points, underscores, etc.
    case Regex.run(~r/<([^\s>]+)/, opening_tag) do
      [_, tag] ->
        IO.puts("  🔍 Tag extrait depuis '#{opening_tag}': '#{tag}'")
        tag
      _ ->
        IO.puts("  ⚠️  Impossible d'extraire le tag depuis: #{opening_tag}")
        ""
    end
  end

  # Extraire les attributs dans l'ordre depuis la balise d'ouverture (noms seulement, avant le =) - utilisé uniquement pour le composant cliqué
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

  # Étape 4.1: Filtrer par tag exact (comparaison stricte tag === clickedTag)
  defp filter_by_exact_tag_strict(components, clicked_tag) do
    filtered = Enum.filter(components, fn comp ->
      comp_tag = comp["tag"] || ""
      match = comp_tag == clicked_tag
      if match do
        IO.puts("  ✓ Match trouvé: '#{comp_tag}' == '#{clicked_tag}' pour '#{comp["Nom du composant"]}'")
      end
      match
    end)

    IO.puts("  📊 Filtrage par tag '#{clicked_tag}': #{length(components)} → #{length(filtered)} candidats")
    filtered
  end

  # Étape 4.2: Filtrer par attributs un par un dans l'ordre
  # Pour chaque attribut dans clickedAttributes :
  # - Garder seulement les composants dont attributes contiennent cet attribut
  # - Si un attribut ne correspond à aucun candidat, ignorer l'attribut et continuer
  defp filter_by_attributes_ordered_strict(candidates, clicked_attributes) do
    Enum.reduce(clicked_attributes, candidates, fn attr_key, current_candidates ->
      if Enum.empty?(current_candidates) do
        current_candidates
      else
        # Filtrer les candidats qui contiennent cet attribut dans leur liste 'attributs'
        filtered =
          Enum.filter(current_candidates, fn comp ->
            comp_attrs = comp["attributs"] || []
            # Vérifier si l'attribut est présent dans la liste
            attr_key in comp_attrs
          end)

        case filtered do
          [] ->
            # Si un attribut ne correspond à aucun candidat, ignorer l'attribut et continuer
            IO.puts("  ⚠️  Attribut '#{attr_key}' ne correspond à aucun candidat, ignoré")
            current_candidates
          filtered_list ->
            IO.puts("  ✓ Attribut '#{attr_key}': #{length(current_candidates)} → #{length(filtered_list)} candidats")
            filtered_list
        end
      end
    end)
  end

end

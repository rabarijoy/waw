defmodule WawShowcase.ComponentExtractor do
  @moduledoc """
  Module pour extraire les composants depuis la dépendance Waw.
  Parcourt lib/waw, récupère les modules et extrait leur documentation.
  """

  defstruct [:nom, :code_source, :module, :tag]

  @doc """
  Récupère tous les composants depuis Waw et les met en cache.
  """
  def load_components do
    require Logger
    Logger.debug("ComponentExtractor.load_components - Starting...")

    # Vérifier si le cache contient une liste vide et la forcer à se recharger
    case :ets.lookup(:waw_showcase_cache, :waw_components) do
      [{:waw_components, components}] when is_list(components) and length(components) > 0 ->
        Logger.debug("ComponentExtractor.load_components - Cache hit: #{length(components)} components")
        components

      [{:waw_components, []}] ->
        Logger.debug("ComponentExtractor.load_components - Cache contains empty list, forcing reload...")
        # Supprimer l'entrée vide et forcer le rechargement
        :ets.delete(:waw_showcase_cache, :waw_components)
        extracted = extract_all_components()
        Logger.debug("ComponentExtractor.load_components - Extracted #{length(extracted)} components")
        :ets.insert(:waw_showcase_cache, {:waw_components, extracted})
        extracted

      _ ->
        Logger.debug("ComponentExtractor.load_components - Cache empty, extracting components...")
        extracted = extract_all_components()
        Logger.debug("ComponentExtractor.load_components - Extracted #{length(extracted)} components")
        :ets.insert(:waw_showcase_cache, {:waw_components, extracted})
        extracted
    end
  end

  @doc """
  Extrait tous les composants depuis le dossier lib/waw de Waw.
  Parcourt récursivement les sous-dossiers et extrait plusieurs composants par fichier.
  """
  def extract_all_components do
    require Logger
    waw_path = get_waw_path()
    Logger.debug("ComponentExtractor.extract_all_components - Waw path: #{inspect(waw_path)}")
    Logger.debug("ComponentExtractor.extract_all_components - Path exists: #{File.exists?(waw_path)}")

    if File.exists?(waw_path) do
      files = list_ex_files_recursive(waw_path)
      Logger.debug("ComponentExtractor.extract_all_components - Found #{length(files)} files")

      components = files
      |> Enum.flat_map(fn file_path ->
        try do
          relative_path = Path.relative_to(file_path, waw_path)
          module_name = path_to_module(relative_path)

          # Extraire tous les composants depuis ce module (peut y en avoir plusieurs)
          extract_all_components_from_module(module_name)
        rescue
          e ->
            Logger.debug("ComponentExtractor.extract_all_components - Error extracting from #{file_path}: #{inspect(e)}")
            []
        end
      end)
      |> Enum.filter(& &1 != nil)

      Logger.debug("ComponentExtractor.extract_all_components - Extracted #{length(components)} components")
      components
    else
      Logger.warn("ComponentExtractor.extract_all_components - Waw path does not exist: #{inspect(waw_path)}")
      []
    end
  end

  # Parcourt récursivement tous les fichiers .ex dans waw_path
  defp list_ex_files_recursive(waw_path) do
    waw_path
    |> Path.join("**/*.ex")
    |> Path.wildcard()
    |> Enum.reject(&String.contains?(&1, "/._"))  # Filtrer les fichiers de métadonnées macOS
    |> Enum.sort()
  end

  @doc """
  Transforme un chemin de fichier relatif en nom de module Elixir.
  Gère les sous-dossiers (ex: "text/number.ex" -> "Waw.Text.Number").
  """
  def path_to_module(relative_path) do
    module_name =
      relative_path
      |> Path.rootname()
      |> String.split("/")
      |> Enum.map(&Macro.camelize/1)
      |> Enum.join(".")
      |> then(&"Waw.#{&1}")

    # Essayer de convertir en atom
    try do
      String.to_existing_atom(module_name)
    rescue
      ArgumentError ->
        # Si le module n'existe pas encore, retourner le nom en string
        module_name
    end
  end

  @doc """
  Extrait tous les composants depuis un module.
  Un module peut contenir plusieurs fonctions publiques, chacune étant un composant.
  """
  def extract_all_components_from_module(module_name) when is_binary(module_name) do
    try do
      module = String.to_existing_atom("Elixir.#{module_name}")
      extract_all_components_from_module(module)
    rescue
      ArgumentError ->
        []
    end
  end

  def extract_all_components_from_module(module) when is_atom(module) do
    try do
      case Code.fetch_docs(module) do
        {:docs_v1, _, _, _, moduledoc, _, docs} ->
          moduledoc_content = extract_moduledoc_content(moduledoc)

          # Extraire tous les composants depuis chaque fonction publique
          # Prioriser les fonctions qui commencent par waw_ pour éviter les fonctions dépréciées
          all_functions =
            docs
            |> Enum.filter(fn
              {{:function, _name, _arity}, _meta, _signature, doc, _metadata} when is_map(doc) ->
                true
              _ ->
                false
            end)
            |> Enum.sort_by(fn {{:function, name, _arity}, _, _, _, _} ->
              name_str = Atom.to_string(name)
              # Prioriser les fonctions waw_* (0) sur les autres (1)
              if String.starts_with?(name_str, "waw_"), do: 0, else: 1
            end)

          components_from_functions =
            all_functions
            |> Enum.map(fn {{:function, function_name, _arity}, _meta, _signature, doc, _metadata} ->
              function_doc_content = doc |> Map.values() |> List.first()

              # Utiliser la fonction doc si elle existe, sinon le moduledoc
              doc_content = function_doc_content || moduledoc_content

              if doc_content do
                # Extraire le nom depuis la fonction doc en priorité
                # Si la fonction doc commence par "## Attributes", utiliser le moduledoc ou le nom de la fonction
                nom =
                  if function_doc_content && String.starts_with?(String.trim(function_doc_content), "##") do
                    # La fonction doc commence par un titre markdown, utiliser le moduledoc ou le nom de la fonction
                    extract_nom(moduledoc_content) || format_function_name(function_name)
                  else
                    extract_nom(function_doc_content) || extract_nom(moduledoc_content) || format_function_name(function_name)
                  end

                # Chercher le code_source dans les deux endroits
                code_source =
                  extract_usage_code(function_doc_content) ||
                  extract_usage_code(moduledoc_content)

                # Le tag est basé sur le nom de la fonction, pas sur le module
                tag = extract_tag_from_function(function_name)

                %__MODULE__{
                  nom: nom,
                  code_source: code_source,
                  module: inspect(module),
                  tag: tag
                }
              else
                nil
              end
            end)
            |> Enum.filter(& &1 != nil)

          # Si aucune fonction n'a de doc, essayer de créer un composant depuis le moduledoc
          if Enum.empty?(components_from_functions) && moduledoc_content do
            nom = extract_nom(moduledoc_content)
            code_source = extract_usage_code(moduledoc_content)

            if nom && nom != "Composant inconnu" do
              # Essayer de trouver la première fonction publique pour le tag
              first_function =
                docs
                |> Enum.find_value(fn
                  {{:function, name, _arity}, _, _, _, _} -> name
                  _ -> nil
                end)

              tag = if first_function, do: extract_tag_from_function(first_function), else: extract_tag(module)

              [
                %__MODULE__{
                  nom: nom,
                  code_source: code_source,
                  module: inspect(module),
                  tag: tag
                }
              ]
            else
              []
            end
          else
            components_from_functions
          end

        _ ->
          []
      end
    rescue
      _ ->
        []
    end
  end

  @doc """
  Extrait les informations d'un composant depuis son module (version legacy, retourne le premier).
  """
  def extract_component(module_name) when is_binary(module_name) do
    extract_all_components_from_module(module_name) |> List.first()
  end

  def extract_component(module) when is_atom(module) do
    extract_all_components_from_module(module) |> List.first()
  end

  @doc """
  Extrait le contenu du moduledoc.
  """
  def extract_moduledoc_content(moduledoc) when is_map(moduledoc) do
    # Le moduledoc est un map avec les langues comme clés (ex: %{"en" => "...", "fr" => "..."})
    moduledoc
    |> Map.values()
    |> List.first()
  end

  def extract_moduledoc_content({:eof, _}) do
    nil
  end

  def extract_moduledoc_content({:markdown, content}) when is_binary(content) do
    content
  end

  def extract_moduledoc_content(_) do
    nil
  end


  @doc """
  Extrait le nom du composant depuis la documentation.
  Ignore les lignes qui commencent par ## (titres markdown).
  """
  def extract_nom(nil), do: "Composant inconnu"

  def extract_nom(doc) when is_binary(doc) do
    doc
    |> String.split("\n")
    |> Enum.find(fn line ->
      trimmed = String.trim(line)
      trimmed != "" && !String.starts_with?(trimmed, "##")
    end)
    |> case do
      nil -> "Composant inconnu"
      line -> String.trim(line)
    end
  end

  @doc """
  Extrait le code source depuis la section ## Usage.
  Supporte différents formats de backticks et de langages.
  """
  def extract_usage_code(nil), do: nil

  def extract_usage_code(doc) when is_binary(doc) do
    # Recherche de la section ## Usage avec le code entre triples backticks
    # Supporte différents formats: ```, ```heex, ```elixir, ```heex\n, etc.
    # Le flag 's' permet à . de matcher les newlines aussi

    # Essayer d'abord avec le format le plus spécifique (avec langue)
    regex1 = ~r/## Usage\s*```(?:heex|elixir)?\s*\n?(.*?)```/ms

    # Ensuite sans langue mais avec newline optionnelle
    regex2 = ~r/## Usage\s*```\s*\n?(.*?)```/ms

    # Enfin, format le plus simple
    regex3 = ~r/## Usage\s*```(.*?)```/ms

    result =
      case Regex.run(regex1, doc) do
        [_, code] -> String.trim(code)
        _ ->
          case Regex.run(regex2, doc) do
            [_, code] -> String.trim(code)
            _ ->
              case Regex.run(regex3, doc) do
                [_, code] -> String.trim(code)
                _ -> nil
              end
          end
      end

    result
  end

  @doc """
  Extrait le nom du tag depuis le nom de la fonction.
  Si la fonction ne commence pas par "waw_", ajoute le préfixe.
  """
  def extract_tag_from_function(function_name) when is_atom(function_name) do
    function_name
    |> Atom.to_string()
    |> then(fn name ->
      if String.starts_with?(name, "waw_") do
        name
      else
        "waw_#{name}"
      end
    end)
  end

  def extract_tag_from_function(_), do: nil

  # Formate le nom de la fonction en nom de composant (ex: :currency -> "Currency")
  defp format_function_name(function_name) when is_atom(function_name) do
    function_name
    |> Atom.to_string()
    |> String.replace("waw_", "")
    |> Macro.camelize()
  end

  defp format_function_name(_), do: "Composant inconnu"

  @doc """
  Extrait le nom du tag depuis le module (ex: Waw.Button -> "waw_button").
  Utilisé comme fallback quand on n'a pas de fonction spécifique.
  """
  def extract_tag(module) when is_atom(module) do
    module
    |> inspect()
    |> String.replace("Elixir.", "")
    |> String.replace("Waw.", "")
    |> Macro.underscore()
    |> then(&"waw_#{&1}")
  end

  def extract_tag(_), do: nil

  # Récupère le chemin vers le dossier lib/waw de Waw.
  defp get_waw_path do
    # Essayer d'abord depuis la configuration de l'application
    case Application.get_env(:waw_showcase, :waw_path) do
      nil ->
        # Utiliser le chemin standard de la dépendance Mix (deps/waw/lib/waw)
        # Depuis la racine du projet (où se trouve mix.exs)
        waw_dep_path = Path.join([File.cwd!(), "deps", "waw", "lib", "waw"])
        waw_dep_path

      path -> path
    end
  end
end

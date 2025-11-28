defmodule WawShowcase.ComponentExtractor do
  @moduledoc """
  Module pour extraire les composants depuis la dépendance Waw.
  Parcourt lib/waw, récupère les modules et extrait leur documentation.
  """

  @waw_path "/Volumes/PortableSSD/School/CNED/2A/Stage/waw-components/lib/waw"

  defstruct [:nom, :code_source, :module, :tag]

  @doc """
  Récupère tous les composants depuis Waw et les met en cache.
  """
  def load_components do
    WawShowcase.Cache.get(:waw_components, fn ->
      extract_all_components()
    end)
  end

  @doc """
  Extrait tous les composants depuis le dossier lib/waw de Waw.
  """
  def extract_all_components do
    waw_path = get_waw_path()

    if File.exists?(waw_path) do
      waw_path
      |> File.ls!()
      |> Enum.filter(&String.ends_with?(&1, ".ex"))
      |> Enum.reject(&String.starts_with?(&1, "._"))  # Filtrer les fichiers de métadonnées macOS
      |> Enum.map(fn file ->
        try do
          module_name = path_to_module(file)
          extract_component(module_name)
        rescue
          _ -> nil
        end
      end)
      |> Enum.filter(& &1 != nil)
    else
      []
    end
  end

  @doc """
  Transforme un chemin de fichier en nom de module Elixir.
  """
  def path_to_module(file) do
    module_name =
      file
      |> Path.rootname()
      |> String.replace("_", " ")
      |> Macro.camelize()
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
  Extrait les informations d'un composant depuis son module.
  """
  def extract_component(module_name) when is_binary(module_name) do
    try do
      module = String.to_existing_atom("Elixir.#{module_name}")
      extract_component(module)
    rescue
      ArgumentError ->
        nil
    end
  end

  def extract_component(module) when is_atom(module) do
    try do
      case Code.fetch_docs(module) do
        {:docs_v1, _, _, _, moduledoc, _, docs} ->
          moduledoc_content = extract_moduledoc_content(moduledoc)

          # Chercher dans la doc de la fonction principale (généralement contient la section ## Usage)
          function_doc_content = extract_from_function_docs(docs)

          # Utiliser la fonction doc si elle existe et contient ## Usage, sinon le moduledoc
          doc_content = function_doc_content || moduledoc_content

          if doc_content do
            # Extraire le nom depuis la fonction doc en priorité, sinon depuis le moduledoc
            nom = extract_nom(function_doc_content) || extract_nom(moduledoc_content)
            # Chercher le code_source dans toutes les fonctions et le moduledoc
            code_source = extract_usage_code_from_all_docs(docs, moduledoc_content)
            tag = extract_tag(module)

            %__MODULE__{
              nom: nom,
              code_source: code_source,
              module: inspect(module),
              tag: tag
            }
          else
            nil
          end

        _ ->
          nil
      end
    rescue
      _ ->
        nil
    end
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

  # Extrait la documentation depuis les fonctions si le moduledoc est vide.
  defp extract_from_function_docs(docs) when is_list(docs) do
    # Chercher la fonction principale (généralement la première fonction publique qui commence par waw_)
    # Prioriser les fonctions qui commencent par waw_
    waw_functions =
      docs
      |> Enum.filter(fn
        {{:function, name, _arity}, _meta, _signature, doc, _metadata} when is_map(doc) ->
          name_str = Atom.to_string(name)
          String.starts_with?(name_str, "waw_")
        _ ->
          false
      end)

    # Si on trouve des fonctions waw_, prendre la première
    # Sinon, prendre la première fonction publique
    result =
      if Enum.empty?(waw_functions) do
        docs
        |> Enum.find_value(fn
          {{:function, _name, _arity}, _meta, _signature, doc, _metadata} when is_map(doc) ->
            doc |> Map.values() |> List.first()
          _ ->
            nil
        end)
      else
        waw_functions
        |> List.first()
        |> then(fn {{:function, _name, _arity}, _meta, _signature, doc, _metadata} ->
          doc |> Map.values() |> List.first()
        end)
      end

    result
  end

  defp extract_from_function_docs(_), do: nil

  # Extrait le code source depuis toutes les fonctions et le moduledoc
  # Cherche dans toutes les fonctions qui contiennent ## Usage
  defp extract_usage_code_from_all_docs(docs, moduledoc_content) when is_list(docs) do
    # D'abord chercher dans le moduledoc
    case extract_usage_code(moduledoc_content) do
      nil ->
        # Ensuite chercher dans toutes les fonctions, en priorisant celles qui commencent par waw_
        waw_functions =
          docs
          |> Enum.filter(fn
            {{:function, name, _arity}, _meta, _signature, doc, _metadata} when is_map(doc) ->
              name_str = Atom.to_string(name)
              String.starts_with?(name_str, "waw_")
            _ ->
              false
          end)

        # Chercher dans les fonctions waw_ d'abord
        case waw_functions
             |> Enum.find_value(fn {{:function, _name, _arity}, _meta, _signature, doc, _metadata} ->
               doc_content = doc |> Map.values() |> List.first()
               extract_usage_code(doc_content)
             end) do
          nil ->
            # Si pas trouvé, chercher dans toutes les autres fonctions
            docs
            |> Enum.find_value(fn
              {{:function, _name, _arity}, _meta, _signature, doc, _metadata} when is_map(doc) ->
                doc_content = doc |> Map.values() |> List.first()
                extract_usage_code(doc_content)
              _ ->
                nil
            end)

          code ->
            code
        end

      code ->
        code
    end
  end

  defp extract_usage_code_from_all_docs(_, moduledoc_content) do
    extract_usage_code(moduledoc_content)
  end

  @doc """
  Extrait le nom du composant depuis la première ligne du moduledoc.
  """
  def extract_nom(nil), do: "Composant inconnu"

  def extract_nom(doc) when is_binary(doc) do
    doc
    |> String.split("\n")
    |> Enum.at(0)
    |> String.trim()
  end

  @doc """
  Extrait le code source depuis la section ## Usage.
  """
  def extract_usage_code(nil), do: nil

  def extract_usage_code(doc) when is_binary(doc) do
    # Recherche de la section ## Usage avec le code entre triples backticks
    # Supporte différents formats: ```, ```heex, ```elixir
    regex = ~r/## Usage\s*```(?:heex|elixir)?\s*(.*?)```/ms

    case Regex.run(regex, doc) do
      [_, code] -> String.trim(code)
      _ ->
        # Essayer aussi sans le préfixe de langue
        regex2 = ~r/## Usage\s*```\s*(.*?)```/ms
        case Regex.run(regex2, doc) do
          [_, code] -> String.trim(code)
          _ -> nil
        end
    end
  end

  @doc """
  Extrait le nom du tag depuis le module (ex: Waw.Button -> "waw_button").
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
    # Essayer de trouver le chemin depuis la dépendance
    case Application.get_env(:waw_showcase, :waw_path) do
      nil -> @waw_path
      path -> path
    end
  end
end

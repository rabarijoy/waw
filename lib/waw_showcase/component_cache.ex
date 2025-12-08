defmodule WawShowcase.ComponentCache do
  @moduledoc """
  Module pour gérer le cache des composants extraits depuis Waw.
  Fournit une interface simple pour rechercher des composants par leur nom de tag.
  """

  @doc """
  Récupère tous les composants depuis le cache.
  S'assure que le cache est chargé avant de retourner les composants.
  Force le chargement si le cache est vide.
  """
  def get_components do
    require Logger

    # Vérifier si le cache est déjà rempli
    case :ets.lookup(:waw_showcase_cache, :waw_components) do
      [{:waw_components, components}] when is_list(components) and length(components) > 0 ->
        # Cache rempli, retourner directement
        Logger.debug("ComponentCache.get_components - Cache hit: #{length(components)} components")
        components

      _ ->
        # Cache vide ou pas encore rempli, charger maintenant de manière synchrone
        Logger.debug("ComponentCache.get_components - Cache miss, loading components synchronously...")
        components = WawShowcase.ComponentExtractor.load_components()
        Logger.debug("ComponentCache.get_components - Loaded #{length(components)} components")
        components
    end
  end

  @doc """
  Recherche un composant par son nom de tag (ex: "waw_button", "input").
  Gère aussi les composants Phoenix standards comme "input".
  Pour les inputs, accepte une option `input_type` pour personnaliser le nom.
  """
  def find_by_tag(tag_name, opts \\ [])

  def find_by_tag(tag_name, opts) when is_binary(tag_name) do
    require Logger
    input_type = Keyword.get(opts, :input_type)

    # D'abord chercher dans les composants Waw
    all_components = get_components()
    Logger.debug("ComponentCache.find_by_tag - Searching for tag: '#{tag_name}', total components: #{length(all_components)}")

    component =
      all_components
      |> Enum.find(fn component ->
        component.tag == tag_name
      end)

    Logger.debug("ComponentCache.find_by_tag - Found: #{inspect(component != nil)}")

    # Si pas trouvé, vérifier si c'est un composant Phoenix standard
    component =
      if component do
        component
      else
        find_phoenix_component(tag_name, input_type: input_type)
      end

    # Pour les inputs, personnaliser le nom avec le type
    if component && tag_name == "input" && input_type do
      type_label = format_input_type(input_type)
      %{component | nom: "Input (#{type_label})"}
    else
      component
    end
  end

  def find_by_tag(_, _), do: nil

  # Formate le type d'input en label lisible
  defp format_input_type("text"), do: "text"
  defp format_input_type("number"), do: "number"
  defp format_input_type("select"), do: "select"
  defp format_input_type("textarea"), do: "textarea"
  defp format_input_type("datetime-local"), do: "datetime-local"
  defp format_input_type("date"), do: "date"
  defp format_input_type("time"), do: "time"
  defp format_input_type("email"), do: "email"
  defp format_input_type("password"), do: "password"
  defp format_input_type(type) when is_binary(type), do: type
  defp format_input_type(_), do: "text"

  # Composants Phoenix standards et exceptions
  defp find_phoenix_component(tag_name, opts \\ [])

  defp find_phoenix_component("input", opts) do
    input_type = Keyword.get(opts, :input_type, "text")
    type_label = format_input_type(input_type)

    %WawShowcase.ComponentExtractor{
      nom: "Input (#{type_label})",
      code_source: "<.input field={@form[:field]} type=\"#{input_type}\" />",
      module: "Phoenix.Component",
      tag: "input"
    }
  end

  defp find_phoenix_component("form", _opts) do
    %WawShowcase.ComponentExtractor{
      nom: "Form",
      code_source: "<.form for={@form} phx-submit=\"save\">\n  <.input field={@form[:field]} />\n</.form>",
      module: "Phoenix.Component",
      tag: "form"
    }
  end

  defp find_phoenix_component("link", _opts) do
    %WawShowcase.ComponentExtractor{
      nom: "Link",
      code_source: "<.link navigate={~p\"/path\"}>Link text</.link>",
      module: "Phoenix.Component",
      tag: "link"
    }
  end

  # Exception: currency est utilisé sans préfixe waw_ dans les templates
  defp find_phoenix_component("currency", _opts) do
    # Chercher waw_currency dans les composants Waw
    get_components()
    |> Enum.find(fn component -> component.tag == "waw_currency" end)
    |> case do
      nil -> nil
      component -> %{component | tag: "currency"}
    end
  end

  defp find_phoenix_component(_, _opts), do: nil

  @doc """
  Recherche un composant par son nom (première ligne de la doc).
  """
  def find_by_nom(nom) when is_binary(nom) do
    get_components()
    |> Enum.find(fn component ->
      component.nom == nom
    end)
  end

  def find_by_nom(_), do: nil
end

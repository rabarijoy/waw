defmodule WawShowcase.ComponentCache do
  @moduledoc """
  Module pour gérer le cache des composants extraits depuis Waw.
  Fournit une interface simple pour rechercher des composants par leur nom de tag.
  """

  @doc """
  Récupère tous les composants depuis le cache.
  """
  def get_components do
    WawShowcase.ComponentExtractor.load_components()
  end

  @doc """
  Recherche un composant par son nom de tag (ex: "waw_button", "input").
  Gère aussi les composants Phoenix standards comme "input".
  """
  def find_by_tag(tag_name) when is_binary(tag_name) do
    # D'abord chercher dans les composants Waw
    component =
      get_components()
      |> Enum.find(fn component ->
        component.tag == tag_name
      end)

    # Si pas trouvé, vérifier si c'est un composant Phoenix standard
    if component do
      component
    else
      find_phoenix_component(tag_name)
    end
  end

  def find_by_tag(_), do: nil

  # Composants Phoenix standards et exceptions
  defp find_phoenix_component("input") do
    %WawShowcase.ComponentExtractor{
      nom: "Input",
      code_source: "<.input field={@form[:field]} type=\"text\" />",
      module: "Phoenix.Component",
      tag: "input"
    }
  end

  defp find_phoenix_component("form") do
    %WawShowcase.ComponentExtractor{
      nom: "Form",
      code_source: "<.form for={@form} phx-submit=\"save\">\n  <.input field={@form[:field]} />\n</.form>",
      module: "Phoenix.Component",
      tag: "form"
    }
  end

  defp find_phoenix_component("link") do
    %WawShowcase.ComponentExtractor{
      nom: "Link",
      code_source: "<.link navigate={~p\"/path\"}>Link text</.link>",
      module: "Phoenix.Component",
      tag: "link"
    }
  end

  # Exception: currency est utilisé sans préfixe waw_ dans les templates
  defp find_phoenix_component("currency") do
    # Chercher waw_currency dans les composants Waw
    get_components()
    |> Enum.find(fn component -> component.tag == "waw_currency" end)
    |> case do
      nil -> nil
      component -> %{component | tag: "currency"}
    end
  end

  defp find_phoenix_component(_), do: nil

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

defmodule WawShowcase.UIConfigCache do
  @moduledoc """
  Cache pour les données UIConfig afin d'éviter les recalculs répétés.
  Utilise un Agent pour maintenir le cache en mémoire.
  """

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Récupère les composants d'une catégorie depuis le cache ou les charge si nécessaire.
  """
  def get_components_by_category(category) do
    case Agent.get(__MODULE__, &Map.get(&1, category)) do
      nil ->
        components = WawShowcase.UIConfig.get_components_by_category(category)
        Agent.update(__MODULE__, &Map.put(&1, category, components))
        components

      cached ->
        cached
    end
  end

  @doc """
  Récupère toutes les catégories préchargées.
  """
  def get_all_categories do
    categories = ["Texte et Nombres", "Basiques", "Dates et heures", "Cartes"]

    Enum.reduce(categories, %{}, fn category, acc ->
      Map.put(acc, category, get_components_by_category(category))
    end)
  end

  @doc """
  Préchage toutes les catégories dans le cache.
  """
  def preload_all do
    get_all_categories()
    :ok
  end

  @doc """
  Vide le cache.
  """
  def clear do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end
end

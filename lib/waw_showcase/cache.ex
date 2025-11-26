defmodule WawShowcase.Cache do
  @moduledoc """
  Module de cache ETS pour stocker les données générées et éviter de les régénérer à chaque mount.
  """

  @table_name :waw_showcase_cache

  @doc """
  Initialise la table ETS pour le cache.
  """
  def init do
    :ets.new(@table_name, [:named_table, :public, :set])
  end

  @doc """
  Récupère les données depuis le cache ou les génère et les met en cache.
  """
  def get(key, generator) when is_function(generator, 0) do
    case :ets.lookup(@table_name, key) do
      [{^key, data}] ->
        data

      [] ->
        data = generator.()
        :ets.insert(@table_name, {key, data})
        data
    end
  end

  @doc """
  Met à jour le cache avec de nouvelles données.
  """
  def put(key, data) do
    :ets.insert(@table_name, {key, data})
    data
  end

  @doc """
  Vide le cache pour une clé spécifique.
  """
  def delete(key) do
    :ets.delete(@table_name, key)
  end

  @doc """
  Vide tout le cache.
  """
  def clear do
    :ets.delete_all_objects(@table_name)
  end
end


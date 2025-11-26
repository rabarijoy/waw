defmodule WawShowcase.Cache do
  @moduledoc """
  Module de cache ETS pour stocker les données générées et éviter de les régénérer à chaque mount.
  """

  @table_name :waw_showcase_cache

  @doc """
  Initialise la table ETS pour le cache.
  """
  def init do
    case :ets.whereis(@table_name) do
      :undefined ->
        :ets.new(@table_name, [:named_table, :public, :set])

      _pid ->
        @table_name
    end
  end

  # S'assure que la table ETS existe, la crée si nécessaire.
  defp ensure_table do
    case :ets.whereis(@table_name) do
      :undefined ->
        init()

      _pid ->
        @table_name
    end
  end

  @doc """
  Récupère les données depuis le cache ou les génère et les met en cache.
  """
  def get(key, generator) when is_function(generator, 0) do
    ensure_table()

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
    ensure_table()
    :ets.insert(@table_name, {key, data})
    data
  end

  @doc """
  Vide le cache pour une clé spécifique.
  """
  def delete(key) do
    ensure_table()
    :ets.delete(@table_name, key)
  end

  @doc """
  Vide tout le cache.
  """
  def clear do
    ensure_table()
    :ets.delete_all_objects(@table_name)
  end
end

defmodule WawShowcase.Cache do
  @moduledoc """
  Module de cache utilisant ETS pour stocker les données générées.
  Évite de régénérer les données à chaque mount.
  """

  @table_name :waw_showcase_cache

  def init do
    :ets.new(@table_name, [:named_table, :public, :set])
  end

  def get(key, generator) when is_function(generator, 0) do
    case :ets.lookup(@table_name, key) do
      [{^key, value}] ->
        value

      [] ->
        value = generator.()
        :ets.insert(@table_name, {key, value})
        value
    end
  end

  def put(key, value) do
    :ets.insert(@table_name, {key, value})
    value
  end

  def clear(key) do
    :ets.delete(@table_name, key)
  end

  def clear_all do
    :ets.delete_all_objects(@table_name)
  end
end


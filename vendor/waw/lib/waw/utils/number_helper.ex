defmodule Waw.NumberHelper do
  @moduledoc """
  Helpers pour les nombres
  """

  require Logger

  def number(value, unit \\ nil, options \\ [style: :narrow])

  def number(value, _, _) when not is_number(value), do: {:safe, "&mdash;"}

  def number(value, nil, _opts) do
    case Cldr.Number.to_string(value, Waw.Cldr) do
      {:ok, formatted} -> formatted
      _ -> {:safe, "&mdash;"}
    end
  end

  def number(value, unit, opts) do
    case Cldr.Unit.to_string(normalize_value(value, unit), Waw.Cldr, opts) do
      {:ok, formatted} -> formatted
      _ -> {:safe, "&mdash;"}
    end
  end

  defp normalize_value(value, :meter) do
    with {:ok, unit} <- Cldr.Unit.new(:meter, value),
         [localized | _] <- Cldr.Unit.localize(unit, Waw.Cldr, usage: :road) do
      Cldr.Unit.round(localized)
    else
      _ -> 0
    end
  end

  defp normalize_value(value, :second) do
    with {:ok, unit} <- Cldr.Unit.new(:second, value),
         rounded <- Cldr.Unit.round(unit),
         [values | _] <-
           Cldr.Unit.decompose(rounded, [:hour, :minute, :second]) do
      values
    else
      _ -> 0
    end
  end

  defp normalize_value(value, unit) do
    Cldr.Unit.new!(unit, value)
  end
end

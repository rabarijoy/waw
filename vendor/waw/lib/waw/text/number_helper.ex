defmodule Waw.Text.NumberHelper do
  @moduledoc """
  Helpers pour les nombres
  """

  require Logger

  def distance(value, u) when is_number(value) do
    with {:ok, unit} <- Waw.Cldr.Unit.new(u, value),
         [localized] <- Waw.Cldr.Unit.localize(unit, usage: :road),
         rounded <- Waw.Cldr.Unit.round(localized),
         {:ok, formatted} <- Waw.Cldr.Unit.to_string(rounded, style: :short) do
      formatted
    else
      _ ->
        {:safe, "&mdash;"}
    end
  end

  def distance(_, _) do
    {:safe, "&mdash;"}
  end

  def currency(value, c) when is_number(value) do
    {:ok, formatted} =
      Waw.Cldr.Number.to_string(value, locale: "fr", currency: c)

    formatted
  end

  def currency(_, _) do
    {:safe, "&mdash;"}
  end

  def number(value, u) when is_number(value) and not is_nil(u) do
    {:ok, formatted} =
      Waw.Cldr.Unit.new!(u, value) |> Waw.Cldr.Unit.to_string()

    formatted
  end

  def number(value, u) when is_number(value) and is_nil(u) do
    value
  end

  def number(_, _) do
    {:safe, "&mdash;"}
  end
end

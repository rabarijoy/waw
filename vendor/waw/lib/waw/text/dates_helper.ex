defmodule Waw.Text.DatesHelper do
  @moduledoc """
  Helpers pour les dates
  """

  require Logger

  def to_iso8601(%DateTime{} = value) do
    DateTime.to_iso8601(value)
  end

  def to_iso8601(%Time{} = value) do
    Time.to_iso8601(value)
  end

  def to_iso8601(%Date{} = value) do
    Date.to_iso8601(value)
  end

  def to_iso8601(value) do
    to_string(value)
  end

  def time_string(value, opts) do
    case Cldr.Time.to_string(value, Waw.Cldr, opts) do
      {:ok, formatted} -> formatted
      _ -> {:safe, "&mdash;"}
    end
  end

  def relative_time_string(value, opts) do
    case Cldr.DateTime.Relative.to_string(value, Waw.Cldr, opts) do
      {:ok, formatted} -> formatted
      _ -> {:safe, "&mdash;"}
    end
  end

  def date_string(value, opts) do
    case Cldr.Date.to_string(value, Waw.Cldr, opts) do
      {:ok, formatted} -> formatted
      _ -> {:safe, "&mdash;"}
    end
  end

  def date_time_string(value, opts) do
    case Cldr.DateTime.to_string(value, Waw.Cldr, opts) do
      {:ok, formatted} -> formatted
      _ -> {:safe, "&mdash;"}
    end
  end

  def interval(from, to, opts \\ [])

  def interval(from, to, opts) do
    case Cldr.Interval.to_string(
           from,
           to,
           Waw.Cldr,
           normalize_interval_options(from, to, opts)
         ) do
      {:ok, formatted} ->
        formatted

      _ ->
        Logger.error(
          "Unable to format interval #{inspect(from)} - #{inspect(to)} opts: #{inspect(opts)}"
        )

        {:safe, "&mdash;"}
    end
  end

  defp normalize_interval_options(_from, _to, opts) do
    opts
    |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
  end

  def local_time do
    {:ok, utc_datetime} = DateTime.now("Etc/UTC")

    {:ok, antananarivo_datetime} =
      DateTime.shift_zone(utc_datetime, "Indian/Antananarivo")

    antananarivo_datetime
  end
end

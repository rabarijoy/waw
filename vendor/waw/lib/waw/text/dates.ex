defmodule Waw.Text.Dates do
  @moduledoc """
  Une composante qui affiche une date, ou une heure.
  ou une intervalle de temps.
  """

  use Phoenix.Component

  alias Waw.Text.DatesHelper, as: H

  attr(:value, :any, required: true, doc: "L'heure à afficher")

  attr(:format, :any,
    default: :medium,
    doc: "Le format de l'heure selon CLDR (voir le format string)",
    values: [:short, :medium, :long, :full]
  )

  attr(:rest, :global)

  def time(assigns) do
    ~H"""
    <span title={H.to_iso8601(@value)} {@rest}>
      {H.time_string(@value, format: @format)}
    </span>
    """
  end

  attr(:from, :any, required: true, doc: "Le début de l'intervalle")
  attr(:to, :any, required: true, doc: "La fin de l'intervalle")

  attr(:format, :any,
    default: :medium,
    doc: "Le format de l'intervalle (Cldr)",
    values: [:short, :medium, :long]
  )

  attr(:style, :any,
    doc: "Le style de l'intervalle (voir Cldr)",
    values: [
      :date,
      :month,
      :month_and_day,
      :year_and_month,
      :flex,
      :time,
      :zone
    ]
  )

  attr(:rest, :global)

  def waw_interval(assigns) do
    ~H"""
    <span title={"#{H.to_iso8601(@from)} - #{H.to_iso8601(@to)}"} {@rest}>
      {H.interval(@from, @to, format: @format, style: assigns[:style])}
    </span>
    """
  end

  @deprecated "Use `waw_interval/1`"
  defdelegate interval(assigns), to: __MODULE__, as: :waw_interval

  attr(:value, :any, required: true, doc: "L'heure à afficher")
  attr(:ref, :any, required: true, doc: "L'heure de référence pour afficher en
    mode relatif")

  attr(:unit, :atom,
    default: nil,
    values: [nil | Cldr.DateTime.Relative.known_units()]
  )

  attr(:rest, :global)

  def waw_relative_time(assigns) do
    ~H"""
    <span title={H.to_iso8601(@value)} {@rest}>
      {H.relative_time_string(@value, relative_to: @ref, unit: @unit)}
    </span>
    """
  end

  @deprecated "Use `waw_relative_time/1`"
  defdelegate relative_time(assigns), to: __MODULE__, as: :waw_relative_time

  attr(:value, :any, required: true, doc: "La date à afficher")

  attr(:format, :any,
    default: :medium,
    doc: "Le format de la date",
    values: [
      :short,
      :medium,
      :long,
      :full
    ]
  )

  attr(:rest, :global)

  def waw_date(assigns) do
    ~H"""
    <span title={H.to_iso8601(@value)} {@rest}>
      {H.date_string(@value, format: @format)}
    </span>
    """
  end

  @deprecated "Use `waw_date/1`"
  defdelegate date(assigns), to: __MODULE__, as: :waw_date

  attr(:value, :any, required: true, doc: "La date à afficher avec l'heure")

  attr(:format, :any,
    default: :medium,
    doc: "Le format de la date et l'heure",
    values: [
      :short,
      :medium,
      :long,
      :full
    ]
  )

  attr(:rest, :global)

  def waw_date_time(assigns) do
    ~H"""
    <span title={H.to_iso8601(@value)} {@rest}>
      {H.date_time_string(@value, format: @format)}
    </span>
    """
  end

  @deprecated "Use `waw_date_time/1`"
  defdelegate date_time(assigns), to: __MODULE__, as: :waw_date_time
end

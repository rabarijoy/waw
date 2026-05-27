defmodule Waw.Text.Number do
  @moduledoc """
  Une composante qui affiche les nombres.
  """

  use Phoenix.Component

  alias Waw.Text.NumberHelper, as: H

  attr(:value, :any, required: true, doc: "Valeur à afficher")

  attr(:unit, :any,
    required: true,
    doc: "Unité"
  )

  attr(:rest, :global)

  def distance(assigns) do
    ~H"""
    <span title={@value} {@rest}>
      {H.distance(@value, @unit)}
    </span>
    """
  end

  attr(:value, :any, required: true, doc: "Valeur à afficher")

  attr(:currency, :string,
    default: "MGA",
    doc: "Unité"
  )

  attr(:rest, :global)

  def currency(assigns) do
    ~H"""
    <span title={@value} {@rest}>
      {H.currency(@value, @currency)}
    </span>
    """
  end

  attr(:value, :any, required: true, doc: "Valeur à afficher")

  attr(:unit, :any,
    default: nil,
    doc: "Unité"
  )

  attr(:options, :any, default: [style: :narrow], doc: "Options")

  attr(:rest, :global)

  def number(assigns) do
    ~H"""
    <span title={@value} {@rest}>
      {Waw.NumberHelper.number(@value, @unit, @options)}
    </span>
    """
  end
end

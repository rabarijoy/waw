defmodule Waw.Text.Text do
  @moduledoc """
  Une composante qui affiche le texte.
  """

  use Phoenix.Component

  alias Waw.Text.TextHelper, as: H

  attr(:value, :any, required: true, doc: "Valeur à afficher")

  attr(:rest, :global)

  def text(assigns) do
    ~H"""
    <span title={@value} {@rest}>
      {H.text(@value)}
    </span>
    """
  end
end

defmodule Waw.StatusCard do
  @moduledoc """
    Afficher la carte de status.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:label, :string,
    doc: "name of the card status.",
    default: "Toutes les informations"
  )

  attr(:icon, :string,
    doc: "icon name of the card status.",
    default: "square-stack-3d-up-fill"
  )

  attr(:state, :string,
    default: "normal",
    values: ["normal", "selected", "disabled", "exception"]
  )

  attr(:text_size, :string,
    values: ["xs", "sm", "base"],
    default: "sm"
  )

  attr(:rest, :global)

  @doc """
  Afficher la carte de status.

  ## Usage

  ```
    <.waw_status_card label="Localisation" icon="world" />
  ```
  """

  def waw_status_card(assigns) do
    ~H"""
    <div
      class={"flex flex-col space-y-4 p-2 h-24 w-24 rounded-xl border #{card_class(@state)}"}
      {@rest}
    >
      <div>
        <.waw_icon name={@icon} size="4" stroke="none" />
      </div>
      <div class={"text-#{@text_size}"}>
        {@label}
      </div>
    </div>
    """
  end

  defp card_class("selected"),
    do: "border-info text-info hover:text-info-primary hover:border-info-primary cursor-pointer"

  defp card_class("disabled"),
    do: "border-default bg-default text-light cursor-default"

  defp card_class("exception"),
    do:
      "border-default bg-default-lite text-light font-medium hover:text-default-primary hover:bg-lite hover:border-lite cursor-pointer"

  defp card_class(_),
    do:
      "border-default bg-default text-default-primary hover:bg-lite hover:border-lite cursor-pointer"
end

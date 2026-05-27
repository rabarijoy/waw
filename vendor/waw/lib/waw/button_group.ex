defmodule Waw.ButtonGroup do
  @moduledoc """
    Afficher un groupe de boutons.
  """
  use Phoenix.Component

  @doc """
  Afficher un groupe de boutons.

  ## Usage

  ```
    <.waw_button_group>
      <.waw_button label="Aujourd'hui" size="md" icon="calendar" icon_position="right" />
      <.waw_button label="Envoyer" size="md" type="submit" />
    </.waw_button_group>
  ```
  """
  slot(:inner_block, required: true)

  attr(:position, :string,
    default: "center",
    doc: "Buttons alignement",
    values: ~w(left center right)
  )

  def waw_button_group(assigns) do
    ~H"""
    <div class={[
      "flex flex-row items-center h-14 w-full space-x-2",
      justify_content(@position)
    ]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp justify_content("left"), do: "justify-start"
  defp justify_content("right"), do: "justify-end"
  defp justify_content(_), do: "justify-center"
end

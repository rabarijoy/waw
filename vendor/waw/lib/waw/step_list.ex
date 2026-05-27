defmodule Waw.StepList do
  @moduledoc """
    Parcourir une liste.
  """
  use Phoenix.Component

  @doc """
  Parcourir une liste.

  ## Usage

  ```
    <.waw_step_list>
      <:left>
        <.waw_button_icon icon="caret-left" icon_size={5} disabled />
      </:left>
      <:right>
        <.waw_button_icon icon="caret-right" icon_size={5} />
      </:right>
    </.waw_step_list>

  ```
  """

  slot(:left)
  slot(:right)
  attr(:rest, :global)

  def waw_step_list(assigns) do
    ~H"""
    <div class="flex flex-row items-center justify-center w-auto h-8 rounded-sm">
      <div id="left" class="flex items-center justify-center w-7" {@rest}>
        {render_slot(@left)}
      </div>
      <div id="right" class="flex items-center justify-center w-7" {@rest}>
        {render_slot(@right)}
      </div>
    </div>
    """
  end
end

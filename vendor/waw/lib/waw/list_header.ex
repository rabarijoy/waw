defmodule Waw.ListHeader do
  @moduledoc """
    Afficher un header de liste pour le tri.
  """
  use Phoenix.Component

  @doc """
  Afficher un header de liste pour le tri.

  ## Usage

  ```
    <.waw_list_header>
      <:left>
        <.waw_button_icon icon="caret-down" />
      </:left>
      <:center>
        <.waw_button_icon icon="caret-down" />
      </:center>
      <:right>
        <.waw_button_icon icon="caret-down" />
      </:right>
    <./waw_list_header>
  ```
  """
  slot(:left)
  slot(:center)
  slot(:right)
  attr(:rest, :global)

  def waw_list_header(assigns) do
    ~H"""
    <div class="flex flex-row items-center justify-center h-9">
      <div class="flex flex-row items-center w-full rounded-md overflow-x-hidden">
        <div class="flex-none w-11 pl-3">
          <div class="flex items-center justify-center w-6 h-6 text-none">
            <div class="flex items-center justify-center ml-4 w-10">
              <div class="inline-block align-text-top" {@rest}>
                {render_slot(@left)}
              </div>
            </div>
          </div>
        </div>

        <div class="grow truncate pl-3">
          <div class="truncate w-full" {@rest}>
            {render_slot(@center)}
          </div>
        </div>

        <div class="flex flex-row w-auto space-x-4 px-1.5 pr-2.5" {@rest}>
          {render_slot(@right)}
        </div>
      </div>
    </div>
    """
  end
end

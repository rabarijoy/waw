defmodule Waw.BlockTitle do
  @moduledoc """
    Titre de bloc.
  """
  use Phoenix.Component
  import Waw.Icons

  @doc """
  Afficher un titre de bloc.

  ## Usage

  ```
    <.waw_block_title label="Trackable sélectionné" icon="car"/>
  ```
  """

  attr(:label, :string)

  attr(:icon, :string,
    doc: "Icon name",
    values: Waw.Icons.icon_list()
  )

  def waw_block_title(assigns) do
    ~H"""
    <div class="flex flex-row items-center justify-start h-12 w-full space-x-2">
      <span :if={assigns[:icon]} class="flex items-center justify-center ml-1">
        <.waw_icon name={@icon} stroke="none" />
      </span>
      <div :if={assigns[:label]} class="font-bold text-base ml-1">
        {@label}
      </div>
    </div>
    """
  end
end

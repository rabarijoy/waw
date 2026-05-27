defmodule Waw.BlockSeparator do
  @moduledoc """
    Séparateur de blocs.
  """
  use Phoenix.Component

  @doc """
  Afficher un séparateur de blocs.

  ## Usage

  ```
    <.waw_block_separator label="4512 WWT" />
  ```
  """

  attr(:label, :string)

  def waw_block_separator(assigns) do
    ~H"""
    <div class="w-full">
      <span class="flex items-center">
        <span class="h-px flex-1 bg-black"></span>
        <span :if={assigns[:label]} class="shrink-0 px-6 font-bold">
          {@label}
        </span>
        <span class="h-px flex-1 bg-black"></span>
      </span>
    </div>
    """
  end
end

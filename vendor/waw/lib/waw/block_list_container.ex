defmodule Waw.BlockListContainer do
  @moduledoc """
    Afficher conteneur de liste de blocs.
  """
  use Phoenix.Component

  @doc """
  Afficher conteneur de liste de blocs.

  ## Usage

  ```
    <.waw_block_list_container>
     ...
    </.waw_block_list_container>
  ```
  """

  slot :block, doc: "content of block" do
    attr(:multicolumn, :boolean)
  end

  def waw_block_list_container(assigns) do
    ~H"""
    <div class="flex flex-wrap overflow-auto no-scrollbar h-full">
      <div
        :for={b <- @block}
        :if={render_slot(@block)}
        class={block_class(b.multicolumn)}
      >
        {render_slot(b)}
      </div>
    </div>
    """
  end

  defp block_class(true),
    do: "flex flex-wrap h-auto mx-2 my-2 overflow-auto no-scrollbar"

  defp block_class(false), do: "w-72 mx-2 my-2"
end

defmodule Waw.Layouts.Layout2s do
  @moduledoc """
    Afficher une mise en page à 2 sections.
  """

  use Phoenix.Component

  slot(:header)
  slot(:section_header)
  slot(:main)

  attr(:section_header_justify_content, :string,
    default: "start",
    values: ~w(start center end)
  )

  attr(:section_header_align_items, :string,
    default: "start",
    values: ~w(start center end)
  )

  @doc """
  Afficher le layout à 2 sections.

  ## Usage

  ```heex
    <.waw_layout_2s>
      <:header>
        ...
      </:header>
      <:section_header>
        ...
      </:section_header>
      <:main>
        ...
      </:main>
    </.waw_layout_2s>
  ```
  """

  def layout_2s(assigns) do
    ~H"""
    <div class="flex flex-col h-screen max-h-screen w-full">
      <div :if={assigns[:header]} class="flex-none w-full">
        {render_slot(@header)}
      </div>

      <div class="flex w-full h-full mt-4">
        <div class="grow space-y-2">
          <div class={[
            "flex h-1/5 w-full",
            section_header_justify_content(@section_header_justify_content),
            section_header_align_items(@section_header_align_items)
          ]}>
            <div id="section_head">
              <div class="w-full">
                {render_slot(@section_header)}
              </div>
            </div>
          </div>
          <div
            id="main"
            class="h-4/5 bg-white overflow-auto border-2 border-lite rounded-md w-full"
          >
            {render_slot(@main)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp section_header_justify_content("start"), do: "justify-start"
  defp section_header_justify_content("center"), do: "justify-center"
  defp section_header_justify_content("end"), do: "justify-end"

  defp section_header_align_items("start"), do: "items-start"
  defp section_header_align_items("center"), do: "items-center"
  defp section_header_align_items("end"), do: "items-end"
end

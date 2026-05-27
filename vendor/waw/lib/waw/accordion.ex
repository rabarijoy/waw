defmodule Waw.Accordion do
  @moduledoc """
  Afficher un accordion.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:id, :string, required: true)

  attr(:has_group, :boolean, default: false)
  attr(:expanded, :boolean, default: false)
  attr(:selected, :boolean, default: false)

  attr(:head_icon, :string, default: "exclamationmark-circle-fill")

  attr(:title, :string, default: "Vehicule")

  attr(:count, :integer, default: 0)
  slot(:inner_block)
  attr(:rest, :global)

  @doc """
  Afficher un accordion.

  ## Usage

  ```
    <.waw_accordion count={12} id="accordion-single-normal">
      ...
    </.waw_accordion>
  ```
  """

  def waw_accordion(assigns) do
    ~H"""
    <div id={"accordion-item-"<>@id} class="w-full overflow-x-hidden">
      <div class="w-full h-12 pt-1.5 bg-lite" id={"accordion-head-"<>@id} {@rest}>
        <div class="cursor-pointer flex flex-row items-center w-full rounded-md">
          <div class="flex-none pl-2 w-14 flex justify-center">
            <div class="flex items-center justify-center w-10 h-10 text-none">
              <div class={"flex items-center justify-center #{text_color(@selected)}"}>
                <div class="flex flex-col items-center mt-0.5">
                  <.waw_icon name={@head_icon} stroke="none" />
                  <%= if assigns[:count] do %>
                    <div
                      :if={@count > 0}
                      class="w-7 h-5 pb-5 text-center border-b-2 border-danger"
                    >
                      <span class="text-danger text-xs">
                        {@count}
                      </span>
                    </div>
                    <div :if={@count == 0} class="w-7 h-5 pb-5 text-center">
                      <span class="text-dark text-xs">
                        {@count}
                      </span>
                    </div>
                  <% end %>
                </div>
              </div>
            </div>
          </div>

          <div class="grow truncate pl-1">
            <div class="truncate text-none text-xs font-semibold">
              <span class={"truncate #{text_color(@selected)}"}>
                {@title}
              </span>
            </div>
          </div>

          <div class="flex-none w-9 flex justify-center">
            <.waw_icon name={arrow_icon(@expanded)} size="5" stroke="none" />
          </div>
        </div>
      </div>

      <div class="border-neutral-70 border-b"></div>

      <div
        :if={!!@expanded and @inner_block}
        id={"accordion-body-"<>@id}
        class={"w-full #{content_class(@has_group)}"}
      >
        <div>
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  defp text_color(true), do: "text-info"
  defp text_color(_), do: "text-dark"

  defp content_class(true), do: "pl-8"
  defp content_class(_), do: ""

  defp arrow_icon(true), do: "angle-small-up"
  defp arrow_icon(_), do: "angle-small-down"
end

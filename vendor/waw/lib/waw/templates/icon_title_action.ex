defmodule Waw.Templates.IconTitleAction do
  @moduledoc """
  Template icon-title-action.
  """
  use Phoenix.Component

  attr(:class, :string, default: "default", values: ["default", "selected"])

  attr(
    :icon_box_size,
    :string,
    doc: "the icon box size. According to the tailwind documentation in `w-` and `h-`.",
    default: "10"
  )

  slot(:icon)
  slot(:label)
  slot(:action)

  @doc """
  Afficher le template à 3 elements: icone-titre(label)-action(boutons).

  ## Usage
  ```
  <.icon_title_action>
    <:icon>
      <.waw_icon name="truck"/>
    </:icon>
    <:label>
    label
    </:label>
    <:action>
      <div>
        <.waw_icon name="caret-down"/>
        <.waw_icon name="caret-down"/>
        <.waw_icon name="caret-down"/>
      </div>
    </:action>
  </.icon_title_action>
  ```
  """

  def waw_icon_title_action(assigns) do
    ~H"""
    <div class="flex flex-row items-center w-full rounded-md">
      <div :if={assigns[:icon]} class="flex-none w-11 pl-2.5">
        <div class={[
          "flex items-center justify-center w-#{@icon_box_size} h-#{@icon_box_size}",
          class(@class)
        ]}>
          {render_slot(@icon)}
        </div>
      </div>

      <div class="grow truncate pl-3">
        <div class={["truncate", class(@class)]}>
          {render_slot(@label)}
        </div>
      </div>

      <div :if={assigns[:action]} class="flex-none min-w-9">
        <div class="flex items-center justify-center">
          {render_slot(@action)}
        </div>
      </div>
    </div>
    """
  end

  @deprecated "Use `#{__MODULE__}.waw_icon_title_action/1`"
  defdelegate icon_title_action(assigns),
    to: __MODULE__,
    as: :waw_icon_title_action

  defp class("default") do
    "text-none"
  end

  defp class("selected") do
    "text-info"
  end
end

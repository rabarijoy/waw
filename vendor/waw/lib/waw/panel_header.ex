defmodule Waw.PanelHeader do
  @moduledoc """
  Afficher l'en-tête du panneau.
  """
  use Phoenix.Component
  import Waw.Icons
  import Waw.Templates.IconTitleAction

  attr(:icon, :string,
    default: "menu-burger",
    values: [
      "truck",
      "car",
      "moto",
      "caret-left",
      "caret-right",
      "caret-down",
      "caret-up",
      "circle-grid-3x3-fill",
      "circle-grid-3x3",
      "list-bullet",
      "menu-burger",
      "square-grid-3x3"
    ]
  )

  attr(:selected, :boolean, default: false)
  attr(:bordered, :boolean, default: true)

  attr(:title, :string, required: true)
  attr(:subtitle, :string)
  attr(:description, :string, default: nil)

  attr(:subtitle_type, :string,
    default: "muted",
    values: ["success", "warning", "danger", "muted", "defective"]
  )

  attr(:title_type, :string,
    default: "selected",
    values: ["normal", "selected"]
  )

  attr(:acronym, :string)

  attr(:icon_color, :string, default: "default-primary")

  attr(
    :icon_box_size,
    :string,
    doc: "the icon box size. According to the tailwind documentation in `w-` and `h-`.",
    default: "10"
  )

  slot(:actions)
  attr(:rest, :global)

  @doc """
  Afficher l'en-tête du panneau.

  ## Usage

  ```
    <.waw_panel_header title="Title" />
  ```
  """

  def waw_panel_header(assigns) do
    ~H"""
    <div class={"flex flex-row items-center h-14 w-full pl-0.5 #{border(@bordered)}"}>
      <.waw_icon_title_action icon_box_size={@icon_box_size}>
        <:icon>
          <div class="flex items-center justify-center">
            <div
              :if={assigns[:acronym]}
              class={"h-6 w-6 rounded-full flex items-center justify-center text-sm " <> acronym_bg_color(@selected) <> " text-neutral-50"}
            >
              {@acronym}
            </div>
            <div
              :if={!assigns[:acronym]}
              class={"cursor-pointer w-12 h-12 flex items-center justify-center text-#{@icon_color}"}
              {@rest}
            >
              <.waw_icon name={@icon} size="5" stroke="none" />
            </div>
          </div>
        </:icon>
        <:label>
          <div class="flex-1">
            <div class="flex flex-col truncate">
              <span
                class={[
                  "text-base w-60 truncate font-semibold",
                  title_type(@title_type)
                ]}
                title={@title}
              >
                {@title}
              </span>
              <div class="flex flex-row">
                <span
                  :if={assigns[:subtitle]}
                  class={[
                    "text-sm truncate font-semibold",
                    subtitle_type(@subtitle_type)
                  ]}
                  title={@subtitle}
                >
                  {@subtitle}
                </span>
                <span
                  :if={assigns[:description]}
                  class="text-sm font-medium text-default-lite"
                >
                  &nbsp;({@description})
                </span>
              </div>
            </div>
          </div>
        </:label>
        <:action>
          <div :if={assigns[:actions]} class="flex" {@rest}>
            <span class="cursor-pointer">
              {render_slot(@actions)}
            </span>
          </div>
        </:action>
      </.waw_icon_title_action>
    </div>
    """
  end

  defp title_type("normal"), do: "text-info-dark"
  defp title_type("selected"), do: "text-info"

  defp subtitle_type("muted"), do: "text-default-lite"
  defp subtitle_type("warning"), do: "text-orange"
  defp subtitle_type("danger"), do: "text-danger"
  defp subtitle_type("success"), do: "text-success"
  defp subtitle_type("defective"), do: "text-dark"
  defp subtitle_type(_), do: "text-default-lite"

  defp acronym_bg_color(true), do: "bg-info hover:bg-info-primary"
  defp acronym_bg_color(_), do: "bg-default-lite hover:bg-default-primary"

  defp border(true) do
    "border-b-2"
  end

  defp border(_) do
    ""
  end
end

defmodule Waw.Card do
  @moduledoc """
    Afficher le card.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:title_icon, :string,
    doc: "Use name of the icon of Tag-IP for title card content.",
    default: "map"
  )

  attr(:info_icon, :string,
    doc: "Icon for informations.",
    default: "info-circle"
  )

  attr(:title, :string, doc: "Title of card component.", default: "itest")

  attr(:tooltip_description, :string,
    doc: "Tooltip for plus informations.",
    default: "Aucune description disponible"
  )

  attr(:state, :string,
    doc: "State of the component between `normal` and `selected`. ",
    default: "normal",
    values: ["normal", "selected"]
  )

  slot :section, doc: "Section on the card" do
    attr(:label, :string)
    attr(:value, :string)
  end

  @spec waw_card(map()) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Afficher le card.

  ## Usage

  ```
    <.waw_card title="Driver Score Card Synthesis" tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules.">
      <:section>
        <.waw_time_section label="Dernier Maj" value="12:30:05" />
        <.waw_date_section label="Dernier CR disponible" value="Aujourd'hui" />
        <.waw_date_section label="1er CR disponible" value="Aujourd'hui" />
      </:section>
    </.waw_card>
  ```
  """

  def waw_card(assigns) do
    ~H"""
    <div class={[
      "flex flex-col hover:cursor-pointer hover:bg-primary w-72 h-64 max-w-sm p-4 rounded-lg shadow",
      class(@state)
    ]}>
      <.waw_icon name={@title_icon} size="4" stroke="none" />
      <div class="text-base font-medium mt-3 h-14 text-dark">
        <span>
          {@title}
        </span>
      </div>
      <div class="flex flex-col justify-between items-between">
        <div class="font-sans w-full max-w-md mx-auto">
          {render_slot(@section)}
        </div>
        <div :if={@tooltip_description != ""} class="group relative">
          <div class="flex flex-col items-center relative">
            <div class="p-3 absolute bottom-0.5 z-10 h-auto w-72 rounded shadow-tooltip text-xs bg-light text-dark invisible opacity-0 group-hover:visible group-hover:opacity-100 shadow-md transition-all ease-in-out delay-150 duration-300 after:absolute after:-bottom-1.5 after:right-2 after:-translate-x-1/2 after:border-solid after:border-t-8 after:border-x-transparent after:border-x-8 after:border-b-0 after:border-t-white">
              <span>
                {@tooltip_description}
              </span>
            </div>
          </div>
          <div class="flex flex-col items-end mt-2">
            <div class="flex flex-col items-end">
              <.waw_icon name={@info_icon} size="4" stroke="none" />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp class("normal") do
    "bg-lite"
  end

  defp class("selected") do
    "border bg-light border-info hover:border-info-primary"
  end

  def waw_time_section(assigns) do
    ~H"""
    <div class="flex flex-wrap w-full my-5">
      <div class="font-semibold text-gray-700 w-2/3 truncate text-sm flex items-center">
        <span>{assigns[:label]}</span>
      </div>
      <div class="font-bold text-gray-700 w-1/3 text-lg flex flex-col items-end">
        <span>{assigns[:value]}</span>
      </div>
    </div>
    """
  end

  def waw_date_section(assigns) do
    ~H"""
    <div class="flex flex-wrap w-full my-2">
      <div class="font-medium text-gray-700 w-2/3 truncate text-xs flex items-center">
        <span>{assigns[:label]}</span>
      </div>
      <div class="font-bold text-gray-700 w-1/3 text-xs flex flex-col items-end">
        <span>{assigns[:value]}</span>
      </div>
    </div>
    """
  end
end

defmodule Waw.LiveButton do
  @moduledoc """
  Afficher le component button collapse
  """
  use Phoenix.Component

  import Waw.Button
  import Waw.Icons

  attr(:search_name, :string, default: "input_name")
  attr(:placeholder, :string, default: "Rechercher")
  attr(:show_menu, :boolean, default: false)
  attr(:show_list, :boolean, default: false)
  attr(:full_width, :boolean, default: false)
  attr(:is_in_subheader, :boolean, default: false)
  attr(:with_search, :boolean, default: false)
  attr(:type, :atom, default: :list, values: [:list, :menu])
  attr(:selected_item, :string)

  attr(:size, :string,
    default: "md",
    doc: "The size of the component.",
    values: ~w(xs sm md lg)
  )

  attr(:rest, :global)
  slot(:results)
  slot(:left)
  slot(:right)
  slot(:actions)
  slot(:column)

  @doc """
  Afficher un button collapse.

  ## Usage

  Exemple de type :list

  ```heex
    <.waw_live_button
      selected_item="Toutes les organisations"
      show_list
    >
      <:results>
        <.waw_li_button>org 1</.waw_li_button>
        <.waw_li_button>org 2</.waw_li_button>
      </:results>
    </.waw_live_button>
  ```

  Exemple de type :menu

  ```heex
    <.waw_live_button type={:menu} selected_item="Aujourd'hui" show_menu>
      <:left>
        <.waw_link_text label="3 derniers jours" size="xs" state="unchecked"/>
        <.waw_link_text label="7 derniers jours" size="xs" state="unchecked" />
        <.waw_link_text label="Cette semaine" size="xs" state="unchecked" />
      </:left>
      <:right>
        <.waw_link_text label="Aujourd'hui" size="xs" state="unchecked" />
        <.waw_link_text label="Hier" size="xs" state="unchecked" />
        <.waw_link_text label="Avant hier" size="xs" state="unchecked" />
      </:right>
      <:actions>
        <.waw_input id="input-single-date" size="sm" type="date"/>
        <.waw_icons name="arrow-small-right" size="4" />
        <.waw_input id="input-single-date" size="sm" type="date"/>
        <.waw_button label="Filtrer" size="xs" outlined />
        <.waw_button label="Annuler" size="xs" state="unchecked" outlined />
      </:actions>
    </.waw_live_button>
  ```
  """

  def waw_live_button(%{type: :list} = assigns) do
    ~H"""
    <div class="relative">
      <div class="w-full hidden lg:flex">
        <.waw_button
          label={@selected_item}
          size={@size}
          icon="angle-small-down"
          icon_position="right"
          full_width={@full_width}
          {@rest}
        />
      </div>
      <div
        class="w-auto mx-1 mt-1 mb-0 pt-0.5 h-7 flex flex-row text-info lg:hidden"
        {@rest}
      >
        <span class="text-sm">{@selected_item}</span>
        <div class="ml-1">
          <.waw_icon name="angle-small-down" size="4" stroke="none" />
        </div>
      </div>
      <div
        :if={@show_list}
        class={"absolute bg-default left-0 min-w-full max-w-xs rounded h-auto z-50 mt-1  #{result_class(@is_in_subheader)}"}
      >
        <div class="h-auto max-h-96 overflow-y-auto p-px space-y-1 items-start justify-center">
          <div :if={@with_search} class="p-px relative w-40 min-w-full">
            <.form {@rest} id={"search_form-#{@search_name}"}>
              <div class="absolute pt-0.5 inset-y-0 left-2.5 flex items-center pointer-events-none text-dark">
                <.waw_icon name="magnifyingglass-search" size="4" stroke="none" />
              </div>
              <input
                type="search"
                id={@search_name}
                name={@search_name}
                autocomplete="off"
                class="pl-8 lg:pl-11 mt-0 input input-primary w-full border-transparent placeholder-default-primary rounded text-xs lg:text-sm h-7 lg:h-8 text-dark pr-2"
                placeholder={@placeholder}
                {@rest}
              />
            </.form>
          </div>
          {render_slot(@results)}
        </div>
      </div>
    </div>
    """
  end

  def waw_live_button(%{type: :menu} = assigns) do
    ~H"""
    <div class="relative">
      <div class="w-full hidden md:flex lg:flex xl:flex 2xl:flex">
        <.waw_button
          label={@selected_item}
          size={@size}
          full_width={@full_width}
          icon="calendar"
          icon_position="right"
          {@rest}
        />
      </div>
      <div
        class="w-auto mx-1 mt-1 mb-0 pt-0.5 h-7 flex flex-row text-info md:hidden lg:hidden xl:hidden 2xl:hidden"
        {@rest}
      >
        <span class="text-sm">{@selected_item}</span>
        <div class="ml-2 pt-0.5">
          <.waw_icon name="calendar" size="3" stroke="none" />
        </div>
      </div>
      <div
        :if={@show_menu}
        class={"h-auto w-auto absolute z-50 bg-light shadow-lg rounded-md sm:mt-6 mt-px border #{result_class(@is_in_subheader)}"}
      >
        <div class="flex border-b">
          <%= if assigns[:column] && length(assigns[:column]) > 0 do %>
            <div
              :for={column <- @column}
              class="grow border-r p-3 flex flex-col space-y-1 items-end justify-center"
            >
              {render_slot(column)}
            </div>
          <% end %>
          <div
            :if={assigns[:left] && length(assigns[:left]) > 0}
            class="grow border-r p-3 flex flex-col space-y-1 items-end justify-center"
          >
            {inspect(assigns[:left])} {render_slot(@left)}
          </div>
          <div
            :if={assigns[:right] && length(assigns[:right]) > 0}
            class="w-32 h-auto p-3 flex flex-col space-y-1 items-start justify-center"
          >
            {inspect(assigns[:right])} {render_slot(@right)}
          </div>
        </div>
        <div
          :if={@actions}
          class="flex flex-row items-center justify-end space-x-2 p-0.5"
        >
          {render_slot(@actions)}
        </div>
      </div>
    </div>
    """
  end

  defdelegate live_button(assigns),
    to: __MODULE__,
    as: :waw_live_button

  slot(:inner_block)
  attr(:rest, :global)
  attr(:active, :boolean, default: false)
  attr(:text_size, :string, default: "sm", values: ["xs", "sm", "lg"])

  def waw_li_button(assigns) do
    ~H"""
    <div
      {@rest}
      class={"min-w-full max-w-full sm:max-w-xs truncate hover:bg-gray-50 rounded px-3 py-1.5 lg:py-2 #{li_selected(@active)} text-#{@text_size}"}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defdelegate li_button(assigns),
    to: __MODULE__,
    as: :waw_li_button

  defp li_selected(true) do
    "text-info cursor-default"
  end

  defp li_selected(_) do
    "text-dark cursor-pointer"
  end

  defp result_class(true), do: "top-10"
  defp result_class(_), do: "top-6 lg:top-14"
end

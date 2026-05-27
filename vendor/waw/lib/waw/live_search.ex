defmodule Waw.LiveSearch do
  @moduledoc """
  Afficher un champs de recherche avec un resultat dans un popup.
  """

  use Phoenix.Component

  import Waw.Icons

  attr :placeholder, :string, default: "Rechercher"
  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :has_filter, :boolean, default: false
  attr :has_active_filter, :boolean, default: false
  attr :size, :string, default: "lg", values: ["sm", "lg"]
  attr :not_in_header, :boolean, default: false
  attr :rest, :global
  slot :filter_icon
  slot :results
  slot :filters

  @doc """
  Afficher un champs de recherche avec un resultat dans un popup.

  ## Usage

  ```heex
    <.waw_live_search
      placeholder="Rechercher"
      name="nom_de_la_recherche"
      phx-change={}
      phx-target={}
      on_blur="blur"
    >
      <:results>
        <.waw_list_group title="Organisations">
          <.waw_li_button>org 1</.waw_li_button>
          <.waw_li_button>org 2</.waw_li_button>
        </.waw_list_group>
        <.waw_list_group title="Flottes">
          <.waw_li_button>flotte 1</.waw_li_button>
          <.waw_li_button>flotte 2</.waw_li_button>
        </.waw_list_group>
      </:results>
    </.waw_live_search>
  ```
  """

  def waw_live_search(assigns) do
    ~H"""
    <div class={"flex flex-row w-full pt-0.5 #{border(@not_in_header)}"}>
      <div class="w-full relative">
        <div class="absolute inset-y-0 w-10 ml-3 flex items-center justify-center pointer-events-none text-dark">
          <.waw_icon
            name="magnifyingglass-search"
            size={icon_size(@size)}
            stroke="none"
          />
        </div>
        <div class="w-full pl-px pr-0.5">
          <.form {@rest} id={"form-#{@id}"}>
            <input
              type="search"
              id={@id}
              name={@name}
              autocomplete="off"
              class="pl-14 mt-0 input input-primary w-full border-transparent placeholder-default-primary rounded text-xs lg:text-sm h-8 text-dark pr-0.5"
              placeholder={@placeholder}
              {@rest}
            />
          </.form>
        </div>
        <div
          :if={@results}
          class={"absolute bg-lite left-0 w-full rounded h-auto max-h-96 overflow-y-auto z-20 mt-2 shadow #{result_class(@has_filter, @not_in_header)}"}
        >
          {render_slot(@results)}
        </div>
        <div
          :if={@filters}
          id={"filter-body-#{@id}"}
          class="absolute hidden bg-lite rounded mt-4 top-8 left-0 w-full shadow-sm"
        >
          {render_slot(@filters)}
        </div>
      </div>
      <div
        :if={@has_filter}
        class={"w-10 h-8 px-px flex items-center justify-center #{filter_button_class(@has_filter)}"}
        {@rest}
      >
        <div class="w-full my-1 border-l border-default-primary">
          <div class={"pt-0.5 flex items-center justify-center cursor-pointer #{icon_filter_class(@has_active_filter)}"}>
            <div class="hover:text-info hover:scale-150 transition duration-75">
              {render_slot(@filter_icon)}
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @deprecated "Use `waw_live_search/1`"
  defdelegate live_search(assigns), to: __MODULE__, as: :waw_live_search

  attr :title, :string
  attr :title_size, :string, default: "lg", values: ["sm", "lg"]
  slot :inner_block

  def waw_list_group(assigns) do
    ~H"""
    <div>
      <div :if={assigns[:title]} class="ml-3 mt-2 h-8">
        <span class={"text-dark font-semibold text-#{assigns[:title_size]}"}>
          {@title}:
        </span>
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @deprecated "Use `waw_list_group/1`"
  defdelegate list_group(assigns), to: __MODULE__, as: :waw_list_group

  defp icon_size("sm"), do: "w-3 h-3"
  defp icon_size("lg"), do: "w-4 h-4"

  defp icon_filter_class(true), do: "text-info scale-150"
  defp icon_filter_class(_), do: "text-default-primary"

  defp result_class(true, _), do: "top-8"
  defp result_class(_, true), do: "top-8"
  defp result_class(_, _), do: "top-12"

  defp border(true), do: "border-b"
  defp border(_), do: ""

  defp filter_button_class(true), do: "flex-none"
  defp filter_button_class(_), do: "hidden"
end

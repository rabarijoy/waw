defmodule Waw.FilterHeader do
  @moduledoc """
  Afficher le header des filtres.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  import Waw.Icons

  attr(:id, :string, required: true)
  attr(:rest, :global)
  attr(:bordered, :boolean, default: true)

  slot(:left)
  slot(:center)
  slot(:right)
  slot(:filter)

  @doc """
  Afficher le header des filtres.

  ## Usage
  ```
  <.waw_filter_header>
    <:left>
      <div>03/09/23 00:00:00</div>
    </:left>
    <:filter>
      <.waw_nav_filter value={120} icon="car" description="car" />
    </:filter>
    <:filter>
      <.waw_nav_filter value={25} icon="moto">
    </:filter>
    <:filter>
      <.waw_nav_filter value={145} title="Total:" active description="Nombre total">
    </:filter>
  </.waw_filter_header>
  ```
  """

  def waw_filter_header(assigns) do
    ~H"""
    <div
      class={"text-dark bg-light h-auto lg:h-20 py-2 lg:py-0 font-medium text-base w-full relative #{border(@bordered)}"}
      {@rest}
    >
      <div class="flex flex-row h-auto lg:h-full px-2 lg:px-0">
        <div
          class="flex lg:hidden w-10 h-8 items-center justify-center px-2.5 py-2 space-y-2 bg-neutral-100 rounded-sm"
          phx-click={show_hide_modal(@id)}
        >
          <.waw_icon name="menu-burger" size="4" stroke="none" />
        </div>
        <div class="hidden lg:flex flex-row items-center justify-start px-4 py-0 space-y-0 space-x-2 grow">
          {render_slot(@left)}
        </div>
        <div
          :if={render_slot(@center)}
          class="hidden lg:flex items-center justify-center grow flex-wrap px-4 py-0 space-y-1 sm:space-y-0 lg:space-y-0 space-x-2"
        >
          {render_slot(@center)}
        </div>
        <div
          :if={assigns[:filter]}
          class="flex items-center justify-end grow flex-wrap space-y-1 sm:space-y-0 lg:space-y-0"
        >
          <%= for {filter, index} <- Enum.with_index(@filter) do %>
            <div
              :if={index == length(@filter) - 1}
              class="pl-2 lg:px-2 pt-0.5 h-6 lg:h-7 text-sm lg:text-base"
            >
              {render_slot(filter)}
            </div>
            <div
              :if={index < length(@filter) - 1}
              class="border-r border-dark px-2 lg:px-4 pt-0.5 h-6 lg:h-7 text-sm lg:text-base"
            >
              {render_slot(filter)}
            </div>
          <% end %>
        </div>
        <div
          :if={render_slot(@right)}
          class="flex flex-row items-center justify-end px-4 py-0 space-y-0 space-x-2 grow"
        >
          {render_slot(@right)}
        </div>
      </div>
      <div
        id={@id}
        class="hidden absolute top-11 left-2 z-50 bg-neutral-100 p-1 rounded-md h-auto w-auto flex-col space-y-1 lg:space-y-2 items-start lg:hidden"
      >
        {render_slot(@left)}
      </div>
    </div>
    """
  end

  def show_hide_modal(js \\ %JS{}, id) when is_binary(id) do
    if id == "with_border" do
      js
      |> JS.toggle(to: "##{id}")
      |> JS.hide(to: "#without_border")
    else
      js
      |> JS.toggle(to: "##{id}")
      |> JS.hide(to: "#witht_border")
    end
  end

  attr(:active, :boolean, default: false)
  attr(:value, :integer, default: 0)
  attr(:title, :string)
  attr(:description, :string, default: "")
  attr(:rest, :global)
  slot(:icon)

  @doc """
  Afficher l' élément du filtre.

  ## Usage
  ```
  <.waw_nav_filter />
  ```
  """

  def waw_nav_filter(assigns) do
    ~H"""
    <div
      :if={Map.get(assigns, :active, false)}
      class={"#{selected(@active)} flex flex-row space-x-2"}
      title={@description}
      {@rest}
    >
      <span :if={assigns[:title]}>{@title}</span>
      <span class="mr-1.5">{@value}</span>
      <div>
        <.waw_icon :if={!assigns[:title]} name={@icon} stroke="none" size="4" />
      </div>
    </div>
    <.link
      :if={!Map.get(assigns, :active, false)}
      class={"#{selected(false)} flex flex-row space-x-2"}
      title={@description}
      {@rest}
    >
      <span :if={assigns[:title]}>{@title}</span>
      <span class="mr-1.5">{@value}</span>
      <div>
        <.waw_icon :if={!assigns[:title]} name={@icon} stroke="none" size="4" />
      </div>
    </.link>
    """
  end

  defp selected(true) do
    "text-info cursor-default"
  end

  defp selected(_) do
    "text-dark hover:text-info-primary"
  end

  defp border(true) do
    "border-b-2"
  end

  defp border(_) do
    ""
  end
end

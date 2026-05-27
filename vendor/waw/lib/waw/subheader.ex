defmodule Waw.Subheader do
  @moduledoc """
  Afficher le sous header.
  """
  use Phoenix.Component

  import Waw.Icons

  slot(:center)
  slot(:breadcrumb)
  slot(:right)

  attr(:rest, :global)

  @doc """
  Afficher le sous header.

  ## Usage
  ```
    <.waw_subheader>
      <:breadcrumb>
        <.waw_nav_breadcrumb>
          <.waw_icons name="home" size="4" />
        </.waw_nav_breadcrumb>
      </:breadcrumb>
      <:breadcrumb>
        <.waw_nav_breadcrumb>2MI</.nav_breadcrumb>
      </:breadcrumb>
      <:breadcrumb>
          <.waw_nav_breadcrumb active>Vue globale</.waw_nav_breadcrumb>
      </:breadcrumb>
      <:right>
        <div>03/09/23 00:00:00</div>
      </:right>
    </.waw_subheader>
  ```
  """

  def waw_subheader(assigns) do
    ~H"""
    <div
      class="flex shadow-lg text-white text-sm sm:text-sm lg:text-base bg-default-primary pt-3 sm:pt-2.5 lg:pt-0 h-12.5 sm:h-14 lg:h-16 font-medium w-full"
      {@rest}
    >
      <div
        :if={not is_nil(render_slot(@breadcrumb))}
        class="mx-2.5 lg:mx-4 h-full grid lg:grid-cols-3 lg:gap-4"
      >
        <div
          :if={assigns[:breadcrumb]}
          class="flex items-center justify-start"
        >
          <%= for {breadcrumb, index} <- Enum.with_index(@breadcrumb) do %>
            {render_slot(breadcrumb)}
            <.waw_icon
              :if={index < length(@breadcrumb) - 1}
              name="angle-small-right"
              size="4"
              stroke="none"
            />
          <% end %>
        </div>

        <div
          :if={@center}
          class="hidden lg:flex items-start w-full lg:items-center justify-center"
        >
          {render_slot(@center)}
        </div>

        <div class="justify-start lg:justify-end flex flex-col sm:flex-row sm:justify-between lg:flex-row w-full sm:items-center lg:items-center py-2 sm:py-0 lg:py-0 space-y-2 sm:space-y-0 lg:space-y-0 lg:space-x-4">
          {render_slot(@right)}
        </div>
      </div>

      <div
        :if={is_nil(render_slot(@breadcrumb))}
        class="mx-4 h-full flex flex-row items-center"
      >
        <div
          :if={@center}
          class="flex items-start w-full flex items-center justify-center"
        >
          {render_slot(@center)}
        </div>

        <div class="justify-end flex flex-row w-auto items-center py-2 space-y-2 space-x-4">
          {render_slot(@right)}
        </div>
      </div>
    </div>
    """
  end

  @deprecated "Use `waw_subheader/1`"
  defdelegate subheader(assigns), to: __MODULE__, as: :waw_subheader

  attr(:active, :boolean, default: false)
  attr(:rest, :global, include: ~w(patch navigate))

  slot(:inner_block, required: true)

  @doc """
  Afficher l' élément du breadcrumb.

  ## Usage
  ```
  <.nav_breadcrumb>
    ...
  </.nav_breadcrumb>
  ```
  """

  def waw_nav_breadcrumb(assigns) do
    ~H"""
    <span :if={Map.get(assigns, :active, false)} class={selected(@active)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    <.link :if={!Map.get(assigns, :active, false)} class={selected(false)} {@rest}>
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @deprecated "Use `waw_nav_breadcrumb/1`"
  defdelegate nav_breadcrumb(assigns), to: __MODULE__, as: :waw_nav_breadcrumb

  defp selected(true) do
    "text-info hover:text-info-primary text-xs md:text-base"
  end

  defp selected(_) do
    "text-white hover:text-info-primary text-xs md:text-base"
  end
end

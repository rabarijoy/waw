defmodule Waw.Pagination do
  @moduledoc """
    Afficher une pagination.
  """
  use Phoenix.Component

  import Waw.Clickable

  @doc """
  Afficher une pagination.

  ## Usage

  ```
    <.waw_pagination label="Page" meta={meta} next_url={next_url} previous_url={previous_url} />

  ```
  """

  attr(:meta, :any,
    doc: "Meta of the pagination",
    default: nil
  )

  attr(:label, :string)
  attr(:previous_page_action, :any, default: nil)
  attr(:next_page_action, :any, default: nil)

  attr(:current_page, :integer, default: 1)
  attr(:total, :integer)
  slot(:left)
  slot(:right)
  attr(:rest, :global)

  def waw_pagination(%{meta: meta} = assigns) when not is_nil(meta) do
    ~H"""
    <div class="flex flex-row items-center justify-center w-auto bg-light h-8 px-2 rounded-sm pl-8">
      <div class="w-auto">
        <div class="text-sm font-semibold text-dark ">
          {@label}
        </div>
      </div>
      <div class="flex items-center justify-center w-11">
        <div class="text-sm font-medium text-dark">
          {@meta.current_page}/{@meta.total_pages}
        </div>
      </div>
      <div class="flex items-center justify-center w-5">
        <%= if is_nil(@meta.previous_page) do %>
          <.waw_button_icon icon="caret-left" icon_size={5} disabled />
        <% else %>
          <.waw_button_icon
            icon="caret-left"
            icon_size={5}
            phx-click={@previous_page_action}
          />
        <% end %>
      </div>
      <div class="flex items-center justify-center w-5">
        <%= if is_nil(@meta.next_page) do %>
          <.waw_button_icon icon="caret-right" icon_size={5} disabled />
        <% else %>
          <.waw_button_icon
            icon="caret-right"
            icon_size={5}
            phx-click={@next_page_action}
          />
        <% end %>
      </div>
    </div>
    """
  end

  def waw_pagination(assigns) do
    ~H"""
    <div class="flex flex-row items-center justify-center w-auto bg-light h-8 px-2 rounded-sm pl-8">
      <div class="w-auto">
        <div class="text-sm font-semibold text-dark ">
          {@label}
        </div>
      </div>
      <div class="flex items-center justify-center w-11">
        <div class="text-sm font-medium text-dark">
          {@current_page}/{@total}
        </div>
      </div>
      <div class="flex items-center justify-center w-5" {@rest}>
        {render_slot(@left)}
      </div>
      <div class="flex items-center justify-center w-5" {@rest}>
        {render_slot(@right)}
      </div>
    </div>
    """
  end
end

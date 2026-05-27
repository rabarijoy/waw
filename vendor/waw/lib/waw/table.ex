defmodule Waw.Table do
  @moduledoc """
    Afficher le tableau Tag-IP.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:without_border, :boolean, default: false)
  slot(:inner_block)

  slot(:thead, doc: "The head on the table")

  slot :tr, doc: "One line on the table" do
    attr(:state, :string, values: ["normal", "selected", "disabled"])
  end

  @doc """
  Afficher le tableau Tag-IP.

  ## Usage
  ```
    <.waw_table>
      <:thead>
        <.waw_th sort_key="desc">Name</.waw_th>
        <.waw_th sort_key="asc">First Name</.waw_th>
      </:thead>
      <:tr state="selected">
        <.waw_td title="Jean">Jean</.waw_td>
        <.waw_td title="Dupont">Dupoint</.waw_td>
      </:tr>
      <:tr state="normal">
        <.waw_td title="Kim">Kim</.waw_td>
        <.waw_td title="Léna" is_link={true} href="https://www.tag-ip.com/">Léna</.waw_td>
      </:tr>
      <:tr state="disabled">
        <.waw_td title="Sam">Sam</.waw_td>
        <.waw_td title="Smith">Smith</.waw_td>
      </:tr>
    </.waw_table>
  ```

  ## Usage without slot
  ```
    <.waw_table>
      <.waw_thead>
        <.waw_th_icon></.waw_th_icon>
        <.waw_th_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_th_icon>
        <.waw_th sort_key="desc">Name</.waw_th>
        <.waw_th sort_key="asc">First Name</.waw_th>
        <.waw_th sort_key="desc">Details</.waw_th>
      </.waw_thead>
      <.waw_tr state="selected">
        <.waw_td_icon><.waw_icon name="square-inset-filled" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Jean">Jean</.waw_td>
        <.waw_td title="Dupont">Dupoint</.waw_td>
        <.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
      </.waw_tr>
      <.waw_tr state="normal">
        <.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Kim">Kim</.waw_td>
        <.waw_td title="Léna">Léna</.waw_td>
        <.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
      </.waw_tr>
      <.waw_tr state="disabled">
        <.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Sam">Sam</.waw_td>
        <.waw_td title="Smith">Smith</.waw_td>
        <.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
      </.waw_tr>
    </.waw_table>
  ```
  """
  def waw_table(assigns) do
    ~H"""
    <div class="flex flex-col w-full">
      <div class={"overflow-x-auto w-full #{border_class(@without_border)}"}>
        <table class="table-auto w-full text-sm">
          <thead :if={@thead}>
            <tr class={[
              if render_slot(@thead) do
                "border-b border-default"
              else
                ""
              end
            ]}>
              {render_slot(@thead)}
            </tr>
          </thead>
          <tbody :if={render_slot(@tr)}>
            <tr :for={t <- @tr} class={tr_class(t.state, false)}>
              {render_slot(t)}
            </tr>
          </tbody>
          <tbody :if={!render_slot(@tr)}>
            {render_slot(@inner_block)}
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  slot(:inner_block)

  def waw_thead(assigns) do
    ~H"""
    <thead>
      <tr class="border-b border-default">
        {render_slot(@inner_block)}
      </tr>
    </thead>
    """
  end

  attr(:state, :string,
    values: ["normal", "selected", "disabled"],
    default: "normal"
  )

  attr(:toggleable, :boolean, default: false)

  attr(:rest, :global)

  slot(:inner_block)

  def waw_tr(assigns) do
    ~H"""
    <tr class={tr_class(@state, @toggleable)} {@rest}>
      {render_slot(@inner_block)}
    </tr>
    """
  end

  attr(:sort_key, :string)

  attr(:text_size, :string,
    values: ["xs", "sm", "base"],
    default: "sm"
  )

  slot(:inner_block)
  attr(:rest, :global)

  def waw_th(assigns) do
    ~H"""
    <th class={"h-10 text-dark font-semibold text-#{@text_size}"} {@rest}>
      <div class="flex flex-row">
        <div class="grow">
          <span>
            {render_slot(@inner_block)}
          </span>
        </div>
        <div
          :if={not is_nil(assigns[:sort_key]) and assigns[:sort_key] == "asc"}
          class="cursor-pointer w-7"
        >
          <.waw_icon name="caret-up" stroke="none" />
        </div>
        <div
          :if={not is_nil(assigns[:sort_key]) and assigns[:sort_key] == "desc"}
          class="cursor-pointer w-7"
        >
          <.waw_icon name="caret-down" stroke="none" />
        </div>
      </div>
    </th>
    """
  end

  slot(:inner_block)
  attr(:rest, :global)

  def waw_th_icon(assigns) do
    ~H"""
    <th class="text-center relative h-8 w-8 text-dark font-medium" {@rest}>
      <span :if={assigns[:inner_block]}>
        {render_slot(@inner_block)}
      </span>
      <div :if={!assigns[:inner_block]} class="h-8 w-8"></div>
    </th>
    """
  end

  attr(:is_link, :boolean)
  attr(:href, :string, default: "#")
  attr(:title, :string, default: "")

  attr(:text_size, :string,
    values: ["xs", "sm", "base"],
    default: "sm"
  )

  attr(:text_position, :string,
    values: ["left", "center", "right"],
    default: "right"
  )

  slot(:description)
  slot(:inner_block)

  def waw_td(assigns) do
    ~H"""
    <td
      :if={!render_slot(@description)}
      class={"text-#{@text_position} pr-1 text-#{@text_size}"}
    >
      <a :if={assigns[:is_link]} href={@href}>
        <span title={@title}>
          {render_slot(@inner_block)}
        </span>
      </a>
      <span :if={!assigns[:is_link]} title={@title}>
        {render_slot(@inner_block)}
      </span>
    </td>
    <td :if={render_slot(@description)} class="text-left pl-3 py-0.5">
      <a :if={assigns[:is_link]} href={@href}>
        <span title={@title}>
          {render_slot(@inner_block)}
        </span>
        <br />
        <span class="text-xs" title={render_slot(@description)}>
          {render_slot(@description)}
        </span>
      </a>
      <div :if={!assigns[:is_link]} title={@title}>
        <span title={@title}>
          {render_slot(@inner_block)}
        </span>
        <br />
        <span class="text-xs" title={render_slot(@description)}>
          {render_slot(@description)}
        </span>
      </div>
    </td>
    """
  end

  attr(:is_link, :boolean)
  attr(:href, :string, default: "#")
  slot(:inner_block)
  attr(:rest, :global)

  def waw_td_icon(assigns) do
    ~H"""
    <td
      :if={assigns[:is_link]}
      class="text-center relative h-8 w-8 cursor-pointor py-0.5"
      {@rest}
    >
      <a href={@href}>
        {render_slot(@inner_block)}
      </a>
    </td>
    <td
      :if={!assigns[:is_link]}
      class="text-center relative h-8 w-8 cursor-default py-0.5"
    >
      <span>
        {render_slot(@inner_block)}
      </span>
    </td>
    """
  end

  defp tr_class("selected", true),
    do: "h-8 cursor-pointer text-info border-b border-default hover:bg-primary"

  defp tr_class("selected", false),
    do: "h-8 cursor-default text-info border-b border-default border-gray-50 hover:bg-primary"

  defp tr_class("disabled", _),
    do: "h-8 cursor-default border-b border-default opacity-25"

  defp tr_class(_, _),
    do:
      "h-8 cursor-pointer border-b border-b border-default hover:text-info-primary hover:bg-primary text-dark"

  defp border_class(true), do: ""
  defp border_class(_), do: "border-t border-default"
end

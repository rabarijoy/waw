defmodule Waw.LiveFilter do
  @moduledoc """
  Filtre d'une liste avec recherche.
  """

  use Phoenix.Component
  import Waw.List

  attr(:rest, :global)
  attr(:list, :list, required: true)
  slot(:left)
  slot(:right)

  @doc """
  Filtre d'une liste avec recherche.

  ## Usage

  ```heex
    <.waw_live_filter>

    </.waw_live_filter>
  ```
  """

  def waw_live_filter(assigns) do
    ~H"""
    <div class="flex flex-row w-full border rounded-md">
      <div :if={@left} class="w-1/2 flex flex-col p-3 space-y-2 border-r">
        <div class="h-auto">
          {render_slot(@left)}
          <ul>
            <.li
              :for={opt <- @list}
              :if={!Map.get(opt, :selected) or !opt.selected}
              title="Ajouter"
            >
              {opt.value}
            </.li>
          </ul>
        </div>
      </div>
      <div :if={@right} class="w-1/2 flex flex-col p-3 space-y-2">
        <div class="h-auto">
          {render_slot(@right)}
          <ul>
            <.li
              :for={opt <- @list}
              :if={!!Map.get(opt, :selected) and !!opt.selected}
              title="Enlever"
            >
              {opt.value}
            </.li>
          </ul>
        </div>
        <select class="hidden" id="filtered-select" multiple="multiple">
          <option
            :for={opt <- @list}
            :if={!!Map.get(opt, :selected) and !!opt.selected}
            value={opt.id}
            selected
          >
            {opt.value}
          </option>
        </select>
      </div>
    </div>
    """
  end

  slot(:inner_block)

  def waw_section_title(assigns) do
    ~H"""
    <div class="h-8">
      <span class="font-semibold text-sm text-dark">
        {render_slot(@inner_block)}
      </span>
    </div>
    """
  end
end

defmodule Waw.StatusBlock do
  @moduledoc """
    Afficher une bloc de status.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:icon, :string,
    doc: "icon name of the card status.",
    default: "info-circle-fill"
  )

  attr(:title, :string,
    doc: "name of the card status.",
    default: ""
  )

  slot(:right, doc: "Action or status on the right of the header")

  attr(:status, :atom,
    default: :info,
    values: [:info, :success, :warning, :danger, :muted, :defective]
  )

  slot(:content)
  slot(:table)
  slot(:pagination)

  attr(:rest, :global)

  @doc """
  Afficher une bloc de status.

  ## Usage

  ```
    <.waw_status_block status={:success} title="Informations balise GPS" icon="tracker">
      <:right>
        <span>Connectée</span>
      </:right>
      <:content>
        <.waw_status_block_content col={2} label="Dernière position" value="10:53:10  31 oct. 2023, -12.31027, 49.30167" />
      </:content>
    </.waw_status_block>
  ```
  """

  def waw_status_block(assigns) do
    ~H"""
    <div class="pt-2 pb-1 h-auto rounded-md border border-default">
      <div class="flex flex-col px-3" {@rest}>
        <div class="flex flex-row text-dark align-top justify-center">
          <div class="w-7">
            <.waw_icon name={@icon} size="4" stroke="none" />
          </div>
          <div class="font-bold grow text-sm mt-px">
            {@title}
          </div>
          <div
            :if={assigns[:right]}
            class={"font-semibold text-xs mt-1 #{status_class(@status)}"}
          >
            {render_slot(@right)}
          </div>
        </div>
        <div :if={assigns[:content]} class="pl-7 mt-0.5 text-default-primary">
          {render_slot(@content)}
        </div>
        <div :if={assigns[:table]} class="mt-0.5 text-default-primary">
          {render_slot(@table)}
        </div>
      </div>
      <div
        :if={assigns[:pagination]}
        class="flex justify-end mt-0.5 text-default-primary"
      >
        {render_slot(@pagination)}
      </div>
    </div>
    """
  end

  attr(:col, :integer, default: 1, doc: "Nombre de colonne")
  attr(:label, :string)
  attr(:value, :string)
  slot(:content_value)

  attr(:text_size, :string,
    values: ["xs", "sm", "base"],
    default: "sm"
  )

  def waw_status_block_content(assigns) do
    ~H"""
    <div class={"#{content_class(@col)} text-#{@text_size}"}>
      <div :if={assigns[:label]} class="w-24 pr-2 font-medium">{@label}</div>
      <div
        :if={assigns[:value]}
        title={@value}
        class={"#{section_class(assigns[:label])}"}
      >
        {@value}
      </div>
      <div
        :if={!!assigns[:content_value] and !assigns[:value]}
        class={"#{section_class(assigns[:label])}"}
      >
        {render_slot(@content_value)}
      </div>
    </div>
    """
  end

  defp content_class(2), do: "flex flex-row py-1"
  defp content_class(_), do: ""

  defp section_class(label) when is_nil(label), do: "w-full"
  defp section_class(_), do: "w-40 truncate"

  defp status_class(:success), do: "text-success"
  defp status_class(:warning), do: "text-orange"
  defp status_class(:danger), do: "text-danger"
  defp status_class(:muted), do: "text-default-lite"
  defp status_class(:defective), do: "text-dark"
  defp status_class(_), do: "text-info cursor-pointer"
end

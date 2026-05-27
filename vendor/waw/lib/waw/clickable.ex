defmodule Waw.Clickable do
  @moduledoc """
    Afficher un text clickable et une icone clickable.
  """
  use Phoenix.Component
  import Waw.Icons

  @doc """
  Afficher un text clickable et une icone clickable.

  ## Usage

  ```
      <.waw_button_text label="X" value="4" title="Changer la vitesse de lecture" />
      <.waw_button_icon icon="arrow-triangle-2-circlepath-refresh" />
  ```
  """

  attr(:icon, :string)
  attr(:disabled, :boolean, default: false)
  attr(:icon_size, :integer, default: 4)
  attr(:title, :string, default: "")
  attr(:bg_color, :string, default: "")
  attr(:rest, :global)

  def waw_button_icon(assigns) do
    ~H"""
    <div class={[button_class(@disabled), @bg_color]} title={@title} {@rest}>
      <.waw_icon name={@icon} size={@icon_size} stroke="none" />
    </div>
    """
  end

  attr(:label, :string, default: "")
  attr(:value, :string, default: "")
  attr(:disabled, :boolean, default: false)
  attr(:title, :string, default: "")
  attr(:rest, :global)

  def waw_button_text(assigns) do
    ~H"""
    <div class={button_class(@disabled)} title={@title} {@rest}>
      <span class="text-sm">
        {@value}{@label}
      </span>
    </div>
    """
  end

  defp button_class(true), do: "cursor-cursor-not-allowed text-default"
  defp button_class(_), do: "cursor-pointer"
end

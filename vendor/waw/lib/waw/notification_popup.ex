defmodule Waw.NotificationPopup do
  @moduledoc """
    Afficher le popup de notification.
  """
  use Phoenix.Component
  import Waw.Icons

  @doc """
  Afficher le popup de notification.

  ## Usage

  ```
    <.waw_notification_popup icon="speedometer-1-right" title="Survitesse en ville" description="RENAULT MIDLUM 210 - 4785 TAG (Poids-lourds secondaires)" time="09:03:41">
      <:show>
        <.waw_button_text label="Afficher" />
      </:show>
      <:close>
        <.waw_button_text label="Fermer" />
      </:close>
    <./waw_notification_popup>
  ```
  """
  attr(:icon, :string)
  attr(:title, :string)
  attr(:description, :string)
  attr(:time, :string, doc: "heure")
  slot(:show)
  slot(:close)
  attr(:rest, :global)
  attr(:is_alert, :boolean, default: true)

  def notification_popup(assigns) do
    ~H"""
    <div class={"flex flex-row items-center justify-center w-80 bg-light rounded-lg h-16 shadow-sm border-4 #{border(@is_alert)}"}>
      <div class="w-11 flex items-center justify-center pl-1">
        <.waw_icon name={@icon} size="5" stroke="none" />
      </div>
      <div class="grow w-52 leading-4 px-1">
        <div title={@title} class="text-sm font-semibold text-dark truncate">
          {@title}
        </div>
        <div
          title={@description}
          class="text-xs text-default-lite font-medium truncate"
        >
          {@description}
        </div>
        <div class="text-xs text-default-lite">
          {@time}
        </div>
      </div>
      <div class="text-dark w-16 border-l h-full">
        <div
          class="flex items-center justify-center border-b-2 border-default h-1/2"
          {@rest}
        >
          {render_slot(@show)}
        </div>
        <div class="flex items-center justify-center h-1/2" {@rest}>
          {render_slot(@close)}
        </div>
      </div>
    </div>
    """
  end

  defp border(true) do
    "border-danger"
  end

  defp border(_) do
    "border-orange"
  end
end

defmodule Waw.TagList do
  @moduledoc """
    Afficher une liste de tags.
  """
  use Phoenix.Component

  @doc """
  Afficher une liste de tags.

  ## Usage

  ```
    <.waw_tag_list title="Flottes">
      <:tag>
        <.waw_badge id="badge-single-scope-complete" label="value" scope="scope" description="Avec étiquette" color="info-dark">
          <:action>
          <.waw_button_icon icon="cancel" bg_color="bg-light" />
          </:action>
        </.waw_badge>
      </:tag>
      <:tag>
        <.waw_badge id="badge-single-scope" label="value" scope="scope" description="Avec étiquette"/>
      </:tag>
      <:tag>
        <.waw_badge id="badge-single-standard" label="value" description="title" color="info">
          <:action>
            <.waw_button_icon icon="cancel" />
          </:action>
        </.waw_badge>
      </:tag>
      <:tag>
        <.waw_badge id="badge-single-default" label="value" color="success"/>
      </:tag>
    </.waw_tag_list>
  ```
  """
  attr(:title, :string, default: "Tags")
  slot(:tag)
  slot(:actions)

  def waw_tag_list(assigns) do
    ~H"""
    <div class="flex flex-col items-stretch w-full h-auto space-y-1">
      <div class="flex ml-0.5">
        <span class="text-base w-full truncate font-medium">
          {@title}
        </span>
      </div>
      <div class="flex flex-row flex-wrap">
        <div :for={t <- @tag} class="m-0.5">
          {render_slot(t)}
        </div>
      </div>
      <div :if={@actions} class="flex items-center justify-end space-x-2 pr-2">
        {render_slot(@actions)}
      </div>
    </div>
    """
  end
end

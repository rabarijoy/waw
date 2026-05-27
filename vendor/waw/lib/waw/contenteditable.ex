defmodule Waw.Contenteditable do
  @moduledoc """
    Afficher un texte éditable.
  """
  use Phoenix.Component

  @doc """
  Afficher un texte éditable.

  ## Usage

  ```
    <.waw_contenteditable label="Name" value="Edit this text">
      <:actions>
        <.waw_button label="Valider" size="xs" />
      </:actions>
    </.waw_contenteditable>
  ```
  """
  attr(:id, :string, required: true)
  attr(:label, :string, default: "")
  attr(:value, :string, default: "Edit this text")
  slot(:status)
  attr(:rest, :global)

  def waw_contenteditable(assigns) do
    ~H"""
    <div class="flex flex-row items-stretch w-full h-auto space-x-2" {@rest}>
      <div :if={String.length(@label) > 0} class="w-auto pt-0.5">
        <span class="font-bold">{@label}:</span>
      </div>
      <div id={@id} contenteditable="true" class="px-2 pt-0.5 grow">
        <p>
          <%= @value %>
        </p>
      </div>
      <div :if={@status} class="p-0.5 text-success">
        {render_slot(@status)}
      </div>
    </div>
    """
  end
end

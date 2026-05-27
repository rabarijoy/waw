defmodule Waw.Link do
  @moduledoc """
   Afficher un lien.
  """
  use Phoenix.Component

  import Waw.Icons
  import Waw.Helpers

  attr(:label, :string, doc: "Étiquette du composant.")

  attr(:size, :string,
    default: "sm",
    doc: "La taille du composant.",
    values: ~w(xs sm md lg)
  )

  attr(:state, :string,
    default: "default",
    doc: "The state to use.",
    values: ~w(default checked unchecked)
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "The disabled button of component."
  )

  attr(:rest, :global, doc: "Arbitrary HTML or phx attributes")

  @doc """
  Lien texte avec type d'états.

  ## Usage

  ```
    <.waw_link_text label="3 derniers jours" size="sm" state="unchecked"/>
  ```
  """

  def waw_link_text(assigns) do
    if assigns[:disabled] do
      ~H"""
      <div
        class={"text-default-lite cursor-not-allowed" <> " " <> size_attr(@size)}
        {@rest}
      >
        <span :if={assigns[:label]} class={"text-" <> @size}>
          {@label}
        </span>
      </div>
      """
    else
      ~H"""
      <.link class={check_attrs(@state) <> " " <> size_attr(@size)} {@rest}>
        <span :if={assigns[:label]} class={"text-" <> @size}>
          {@label}
        </span>
      </.link>
      """
    end
  end

  attr(:size, :string,
    default: "md",
    doc: "La taille du composant.",
    values: ~w(xs sm md lg)
  )

  attr(:icon, :string,
    doc: "Icon name",
    values: Waw.Icons.icon_list()
  )

  attr(:state, :string,
    default: "default",
    doc: "The state to use.",
    values: ~w(default checked unchecked)
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "The disabled button of component."
  )

  attr(:rest, :global, doc: "Arbitrary HTML or phx attributes")

  @doc """
  Lien icône avec type d'états.

  ## Usage

  ```
    <.waw_link_icon size="sm" state="unchecked" icon="home"/>
  ```
  """

  def waw_link_icon(assigns) do
    if assigns[:disabled] do
      ~H"""
      <div class="text-default-lite cursor-not-allowed" {@rest}>
        <span :if={assigns[:icon]}>
          <.waw_icon name={@icon} size={icon_size(@size)} stroke="none" />
        </span>
      </div>
      """
    else
      ~H"""
      <.link class={check_attrs(@state)} {@rest}>
        <span :if={assigns[:icon]}>
          <.waw_icon name={@icon} size={icon_size(@size)} stroke="none" />
        </span>
      </.link>
      """
    end
  end

  defp check_attrs(state) do
    case state do
      "default" -> "text-dark hover:text-info-primary"
      "checked" -> "text-info hover:text-info-primary"
      "unchecked" -> "text-dark hover:text-info-primary"
    end
  end
end

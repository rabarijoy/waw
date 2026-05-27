defmodule Waw.Flash do
  @moduledoc """
  Afficher un flash.
  """
  use Phoenix.Component
  alias Phoenix.Flash

  alias Phoenix.LiveView.JS

  import Waw.Icons
  import Waw.Helpers

  @doc """
    Afficher le Flash d'alerte.

  ## Usage

  ```
    <.waw_flash kind={:success} title="title">
      <span>
      The arbitrary HTML attributes to add to the flash container
      </span>
    </.waw_flash>
  ```

  ou

  ```
    <.waw_flash kind={:info} title="title" flash={%{"info" => "info!"}} />

  ```

  ## Note: Le bouton(Ouvrir Flash) ne marche pas dans l'onglet Playground.


  Le clé du flash(success ou info ou warning ou error).

  Exemple:
  %{
    "info" => "Serveur erreur."
  }
  """

  attr(:id, :string,
    default: "flash",
    doc: "the optional id of flash container"
  )

  attr(:flash, :map, default: %{}, doc: "the map of flash messages to display")

  attr(:title, :string, default: nil)

  attr(:kind, :atom,
    default: :success,
    values: [:success, :info, :warning, :error],
    doc: "used for styling and flash lookup"
  )

  attr(:rest, :global, doc: "the arbitrary HTML attributes to add to the flash container")

  slot(:inner_block,
    doc: "the optional inner block that renders the flash message"
  )

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={"fixed top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1 " <> class_kind(@kind)}
      {@rest}
    >
      <p
        :if={@title}
        class="flex items-center gap-1.5 text-sm font-semibold leading-6 pr-4"
      >
        <.waw_icon name={icon_kind(@kind)} size="4" stroke="none" />

        {@title}
      </p>
      <p class={"text-sm leading-5 pr-4 " <> space_title_msg(@title)}>
        {msg}
      </p>
      <button
        type="button"
        class="group absolute top-1 right-1 p-2"
        aria-label="close"
      >
        <.waw_icon name="cancel" size="5" stroke="none" />
      </button>
    </div>
    """
  end

  @doc """
  Afficher le groupe de flash avec le contenu standard.

  ## Usage

      <.waw_flash_group flash={@flash} />
  """

  attr(:flash, :map, required: true, doc: "the map of flash messages")

  def flash_group(assigns) do
    ~H"""
    <div>
      <.flash id="flash_info" kind={:info} title={@title} flash={@flash} />
      <.flash id="flash_error" kind={:error} title={@title} flash={@flash} />
      <.flash id="flash_warning" kind={:warning} title={@title} flash={@flash} />
      <.flash id="flash_success" kind={:success} title={@title} flash={@flash} />
    </div>
    """
  end

  defp class_kind(kind) do
    case kind do
      :success -> "text-success bg-white ring-lime-500 fill-lime-400"
      :info -> "text-info bg-white ring-blue-500 fill-blue-900"
      :warning -> "text-yellow-500 bg-white ring-yellow-500 fill-yellow-900"
      :error -> "text-danger bg-white ring-red-500 fill-red-900"
      _ -> "text-emerald-800 bg-white ring-emerald-500 fill-cyan-900"
    end
  end

  defp icon_kind(kind) do
    case kind do
      :success -> "checkmark-icloud-fill"
      :error -> "exclamationmark-circle-fill"
      _ -> "info-circle-fill"
    end
  end

  defp space_title_msg(title) do
    if title do
      "mt-2"
    else
      "mt-0.5"
    end
  end
end

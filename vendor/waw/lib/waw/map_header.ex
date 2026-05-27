defmodule Waw.MapHeader do
  @moduledoc """
    Afficher l'entête de page de la carte.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:time, :string, default: "")
  attr(:time_title, :string, default: "")
  attr(:input_name, :string, required: true)
  attr(:min, :integer, default: 0)
  attr(:max, :integer, default: 0)
  attr(:value, :integer, default: 0)
  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Afficher l'entête de page de la carte.

  ## Usage

  ```
    <.waw_map_header>
      <.waw_button_icon icon="playpause-left-fill" icon_size={5} title="Départ précédent" />
      <.waw_button_icon icon="backward-end-alt-fill" icon_size={5} title="Evénement précédent" />
      <.waw_button_icon icon="backward-end-fill" title="Point précédent"/>
      <.waw_button_icon icon="play-fill" />
      <.waw_button_icon icon="forward-end-fill" title="Point suivant" disabled />
      <.waw_button_icon icon="forward-end-alt-fill" icon_size={5} title="Evénement suivant" disabled />
      <.waw_button_icon icon="playpause-right-fill" icon_size={5} title="arrêt suivant" disabled />
      <.waw_button_text label="X" value="4" title="Changer la vitesse de lecture" />
      <.waw_button_icon icon="arrow-triangle-2-circlepath-refresh" />
    </.waw_map_header>
  ```
  """

  def map_header(assigns) do
    ~H"""
    <div class="w-full text-sm">
      <div class="flex flex-row items-center h-14 w-full px-2.5 bg-lite text-dark">
        <div class="grow px-2 flex justify-center">
          <div class="flex flex-row justify-between w-full max-w-lg">
            {render_slot(@inner_block)}
          </div>
        </div>

        <div class="w-24" title={@time_title}>
          <span class="px-1.5 font-medium">
            {@time}
          </span>
          <.waw_icon name="clock" size="4" stroke="none" />
        </div>
      </div>
      <div class="w-full -mt-0.5">
        <.form {@rest} id={"form-#{@input_name}"}>
          <input
            type="range"
            id={@input_name}
            name={@input_name}
            min={@min}
            max={@max}
            value={@value}
            class="flex w-full h-1"
            {@rest}
          />
        </.form>
      </div>
    </div>
    """
  end
end

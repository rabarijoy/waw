defmodule Waw.FuelCard do
  @moduledoc """
  Afficher une modele de carte pour le volume de carburant.
  """
  use Phoenix.Component

  import Waw.Icons
  attr(:title, :string, default: "")
  attr(:number, :string, default: "")
  attr(:value, :string, default: "")

  @doc """
  Carte pour le volume de carburant

  ## Usage

  ```
    <.waw_fuel_card
      title="Consommation totale de carburant de la flotte"
      number="1510"
      value="35"
    />
  ```
  """

  def waw_fuel_card(assigns) do
    ~H"""
    <div>
      <div class="flex-none w-80 max-w-full py-4 px-6 mt-0 border-black/12.5 shadow-xl relative break-words rounded-2xl border-0 border-solid bg-white bg-clip-border">
        <div class="flex mb-2 h-11 items-center">
          <div class="w-6 mt-0.5 mr-3">
            <div class="flex items-center justify-center min-w-full h-6 mr-2 text-center bg-center rounded fill-current shadow-soft-2xl bg-gradient-to-tl from-purple-700 to-pink-500 text-white">
              <.waw_icon name="fuel-pump" stroke="none" />
            </div>
          </div>
          <p class="mb-0 font-semibold leading-tight text-sm">{@title}</p>
        </div>
        <h4 class="font-bold -mt-2">{@number}L</h4>
        <div class="text-xs h-0.75 flex w-full overflow-visible rounded-lg bg-gray-200">
          <div
            class="duration-600 ease-soft -mt-0.38 -ml-px flex h-1.5 flex-col justify-center overflow-hidden whitespace-nowrap rounded-lg bg-success text-center text-white transition-all"
            style={"width: #{@value}%;"}
          >
          </div>
        </div>
      </div>
    </div>
    """
  end
end

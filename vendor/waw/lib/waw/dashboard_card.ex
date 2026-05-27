defmodule Waw.DashboardCard do
  @moduledoc """
  Afficher une carte avec camembert ou graphe comme contenu.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:title, :string, default: "")
  attr(:description, :string, default: "Aucune description disponible")
  attr(:icon, :string)

  slot(:inner_block)

  @doc """
  Afficher une carte avec camembert ou graphe comme contenu.

  ## Usage

  ```
    <.waw_dashboard_card
      title="statistique par type"
      description="Information concernant le départ des véhicules"
      icon="clock"
    >
      <div class="grid place-content-center p-4 h-full">
        Pie content
      </div>
    </.waw_dashboard_card>
  ```
  """

  def waw_dashboard_card(assigns) do
    ~H"""
    <div class="col-span-2 row-span-2 bg-white rounded-2xl bg-clip-border border border-gray-300">
      <div class="relative flex flex-col min-w-0 break-words text-dark h-full">
        <div class="h-full flex flex-col">
          <div :if={assigns[:icon]} class="text-left inline-block p-4 -mt-1 h-11">
            <.waw_icon name={@icon} stroke="none" size="6" />
          </div>
          <div :if={assigns[:icon]} class="flex-none max-w-full p-4">
            <p class="font-sans font-semibold leading-normal text-sm h-11">
              {@title}
            </p>
          </div>
          <div :if={!assigns[:icon]} class="flex flex-none max-w-full p-4 h-11">
            <p class="font-sans font-semibold leading-normal text-sm">
              {@title}
            </p>
          </div>
          <div class="h-80 grow pt-0">
            <div class="h-full font-bold text-3xl">
              {render_slot(@inner_block)}
            </div>
          </div>
        </div>
        <div :if={@description != ""} class="group relative">
          <div class="flex flex-col items-center relative mx-0.5">
            <div class="p-3 absolute bottom-0.5 z-10 bg-neutral-40 h-auto w-full rounded shadow-tooltip text-xs bg-white text-white-200 invisible opacity-0 group-hover:visible group-hover:opacity-100 shadow-md transition-all ease-in-out delay-150 duration-300 after:absolute after:-bottom-1.5 after:right-2 after:-translate-x-1/2 after:border-solid after:border-t-8 after:border-x-transparent after:border-x-8 after:border-b-0 after:border-t-white">
              <span>
                {@description}
              </span>
            </div>
          </div>
          <div class="flex flex-col items-end mt-2">
            <div class="flex flex-col items-end p-4 pt-0">
              <.waw_icon name="info-circle" size="4" stroke="none" />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

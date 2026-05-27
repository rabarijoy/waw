defmodule Waw.MapFooter do
  @moduledoc """
    Afficher le pied de page de la carte.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import Waw.Icons

  slot(:left_section)
  slot(:right_section)
  attr(:rest, :global)

  @doc """
  Afficher le pied de page de la carte.

  ## Usage

  ```
    <.waw_map_footer>
      <:left_section>
        <.waw_head_section icon="flag-circle-fill" title="Localisation" />
        <.waw_content>
          <.waw_section label="Date/heure" value="03/11/2023 à 10:53:01" description="03/11/2023 à 10:53:01" />
          <.waw_section label="Position" value="-19,39916 ,47,4406" description="-19,39916 ,47,4406" />
        </.waw_content>
      </:left_section>
      <:right_section>
        <.waw_head_section icon="car" title="Véhicule" />
        <.waw_content col={2}>
          <.waw_section label="Contact" value="OFF" description="OFF" />
          <.waw_section label="Moteur" value="OFF" description="OFF" />
          <.waw_section label="Odomètre" value="342 699,20 km" description="342 699,20 km" />
          <.waw_section label="Carburant" value="171,7 l" description="171,7 l" />
          <.waw_section label="RPM" value="0" description="0" />
        </.waw_content>
      </:right_section>
    </.waw_map_footer>
  ```
  """

  def map_footer(assigns) do
    ~H"""
    <div id="container" class="relative flex flex-row h-auto w-full border-t">
      <div
        id="down"
        class="absolute hidden top-1.5 right-4 cursor-pointer"
        phx-click={open()}
      >
        <.waw_icon name="angle-small-up" size="6" stroke="none" />
      </div>
      <div
        id="up"
        class="absolute top-1.5 right-4 cursor-pointer"
        phx-click={closed()}
      >
        <.waw_icon name="angle-small-down" size="6" stroke="none" />
      </div>
      <div class="basis-1/3 py-2.5 flex justify-center px-4 border-r">
        <div class="w-60">
          {render_slot(@left_section)}
        </div>
      </div>
      <div class="basis-2/3 py-2.5 px-4 lg:px-14 xl:px-20">
        <div>
          {render_slot(@right_section)}
        </div>
      </div>
    </div>
    """
  end

  slot(:inner_block)
  attr(:id, :string, default: "content")
  attr(:col, :integer, default: 1, doc: "Nombre de colonne")

  def content(assigns) do
    ~H"""
    <div id={@id} class={content_class(@col)}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:icon, :string,
    doc: "Icon name of the section.",
    default: "info-circle-fill"
  )

  attr(:title, :string, doc: "Title of the section.", default: "")

  def head_section(assigns) do
    ~H"""
    <div class="flex flex-row text-default-primary">
      <div class="w-7 h-8">
        <.waw_icon name={@icon} size="4" stroke="none" />
      </div>
      <span class="text-sm font-semibold">
        {@title}
      </span>
    </div>
    """
  end

  attr(:label, :string)
  attr(:value, :string)
  attr(:description, :string, default: "")

  def section(assigns) do
    ~H"""
    <div class="flex flex-row text-xs cursor-default h-6">
      <div class="w-24 mr-2 font-semibold">{@label}</div>
      <div title={@description} class="w-36 text-ellipsis overflow-hidden">
        {@value}
      </div>
    </div>
    """
  end

  defp content_class(2), do: "grid lg:grid-cols-2 gap-x-8 gap-y-0"
  defp content_class(_), do: "grid gap-x-8 gap-y-0"

  defp open(js \\ %JS{}) do
    js
    |> JS.show(to: "#up")
    |> JS.hide(to: "#down")
    |> JS.add_class("h-auto", to: "#container")
    |> JS.remove_class("hidden", to: "#left_section")
    |> JS.add_class("block", to: "#left_section")
    |> JS.remove_class("hidden", to: "#right_section")
    |> JS.add_class("block", to: "#right_section")
    |> JS.remove_class("h-11", to: "#container")
  end

  defp closed(js \\ %JS{}) do
    js
    |> JS.show(to: "#down")
    |> JS.hide(to: "#up")
    |> JS.add_class("h-11", to: "#container")
    |> JS.add_class("hidden", to: "#left_section")
    |> JS.add_class("hidden", to: "#right_section")
    |> JS.remove_class("h-auto", to: "#container")
  end
end

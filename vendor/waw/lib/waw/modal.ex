defmodule Waw.Modal do
  @moduledoc """
   Component modal
  """
  use Phoenix.Component

  import Waw.Helpers
  import Waw.Icons

  @doc """
  Modal dans une page

  ## Usage

  ```
    <.waw_modal id="modal-single-simple-modal" show>
      <:title>
        Ajout du véhicule
      </:title>
      <:subtitle>
        Flotte Tag-ip
      </:subtitle>
      <:cancel>
        <.waw_button_icon icon="cancel" icon_size={5} stroke="none" />
      </:cancel>
      <:header>
        Informations de base du véhicule
        <.waw_pagination label="Etape" total={4} current_page={1}>
          <:left>
            <.waw_button_icon icon="caret-left" icon_size={5} disabled />
          </:left>
          <:right>
            <.waw_button_icon icon="caret-right" icon_size={5} />
          </:right>
        </.waw_pagination>
      </:header>
      <:content>
        <.input id="input-single-text" size="md" type="text" placeholder="Marque/Modèle" label="Marque/Modèle" />
        <.input id="input-single-text-1" label="Année de fabrication" size="md" type="text" placeholder="Année de fabrication" />
        <.input id="input-single-text-2" label="Numéro de châssis" size="md" type="text" placeholder="Numéro de châssis" />
        <.input id="input-single-text-3" label="Plaque d'immatriculation" size="md" type="text" placeholder="Plaque d'immatriculation" />
        <.input id="input-single-text-4" label="Numéro de série" size="md" type="text" placeholder="Numéro de série" />
        <.input id="input-single-select" label="Type de véhicule" size="md" type="select">
          <option>Voiture</option>
          <option>Camion</option>
          <option>Fourgon</option>
          <option>Autre</option>
        </.input>
        <.input id="input-single-text-6" label="Couleur du véhicule" size="md" type="text" placeholder="Couleur du véhicule" />
      </:content>
      <:actions>
        <.waw_button label="Annuler" size="md" type="cancel" />
        <.waw_button label="Précédent" size="md" state="unchecked" icon="angle-left"/>
        <.waw_button label="Suivant" size="md" state="unchecked" icon="angle-right" icon_position="right"/>
      </:actions>
    </.waw_modal>
  ```
  """

  attr(:id, :string, required: true)
  attr(:show, :boolean, default: false)
  attr(:rest, :global)
  slot(:title, required: true)
  slot(:subtitle)
  slot(:cancel)
  slot(:content, required: true)
  slot(:header)
  slot(:actions)

  def waw_modal(assigns) do
    ~H"""
    <div id={@id} phx-mounted={@show && show_modal(@id)} class="relative z-50">
      <div
        id={"#{@id}-bg"}
        class="bg-zinc-50/90 fixed inset-0 transition-opacity"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-auto min-w-96 max-w-full">
            <.focus_wrap
              id={"#{@id}-container"}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-md bg-white shadow-lg ring-1 transition px-1"
            >
              <div class="relative flex items-center justify-between p-2 pr-1 border-b border-default">
                <div class="flex items-center flex-row">
                  <div class="w-7 pl-1.5">
                    <.waw_icon name="square-and-pencil" stroke="none" size="4" />
                  </div>
                  <span class="px-2">
                    <h3 class="font-semibold text-dark text-sm">
                      {render_slot(@title)}
                    </h3>
                    <span
                      :if={render_slot(@subtitle)}
                      class="text-sm font-medium text-default-lite"
                    >
                      {render_slot(@subtitle)}
                    </span>
                  </span>
                </div>
                <button
                  :if={assigns[:cancel]}
                  type="button"
                  class="absolute top-2 right-1 flex items-center justify-center w-6 h-6 bg-default border-default border-2 rounded"
                  aria-label="close"
                >
                  {render_slot(@cancel)}
                </button>
              </div>
              <div class="py-2 px-1">
              <div class="p-1.5 pt-0">
                <div
                  :if={assigns[:header]}
                  class="flex flex-row items-center justify-between space-x-4 font-semibold text-default-lite text-xs"
                >
                  {render_slot(@header)}
                </div>
                <div id={"#{@id}-content"} class="mt-2 flex flex-col space-y-3">
                  {render_slot(@content)}
                </div>
                <div
                  :if={assigns[:actions]}
                  id={"#{@id}-actions"}
                  class="mt-4 pt-2 md:pt-3 flex flex-row space-x-2 justify-end"
                >
                  {render_slot(@actions)}
                </div>
              </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

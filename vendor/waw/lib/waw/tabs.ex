defmodule Waw.Tabs do
  @moduledoc """
    Afficher les onglets.
  """
  use Phoenix.Component

  attr(:align_tab, :string,
    default: "left",
    doc: "The tab alignment",
    values: ~w(left center right)
  )

  attr(:size, :string,
    default: "lg",
    doc: "The size for the tab component only.",
    values: ~w(sm lg)
  )

  slot(:actions, doc: "Actions on the right")
  slot(:inner_block)

  @doc """
  Afficher les onglets.

  ## Usage

  ```
    <.waw_tabs size="sm" align_tab="left">
      <.waw_tab size="sm" active>
        Items
      </.waw_tab>
      <.waw_tab size="sm">
        Flottes
      </.waw_tab>
      <.waw_tab size="sm" disabled>
        Instances
      </.waw_tab>
      <:actions>
        <.waw_button label="Créer" size="sm" />
        <.waw_button label="Rafraîchir" size="sm" icon="home" />
        <.inputs id="inputs-single-search-litle" size="sm" type="search"/>
      </:actions>
    </.waw_tabs>
  ```

  """

  def waw_tabs(assigns) do
    ~H"""
    <header class="flex justify-between w-full border-b border-gray-300">
      <div class="flex">
        {render_slot(@inner_block)}
      </div>
      <div class="flex items-center justify-center space-x-2 pb-1">
        {render_slot(@actions)}
      </div>
    </header>
    """
  end

  attr(:active, :boolean, default: false, doc: "The active tab of component")

  attr(:disabled, :boolean,
    default: false,
    doc: "If true, the component will disabled of tabs."
  )

  slot(:inner_block, required: true)
  attr(:rest, :global)

  attr(:size, :string,
    default: "lg",
    doc: "The size for the tab component only.",
    values: ~w(sm lg)
  )

  @doc """
  Afficher le tab.

  ## Usage
  ```
    <.waw_tab size="sm" active>
      Items
    </.waw_tab>
    <.waw_tab size="sm">
      Flottes
    </.waw_tab>
    <.waw_tab size="sm" disabled>
      Instances
    </.waw_tab>
  ```
  """

  def waw_tab(assigns) do
    ~H"""
    <button {button_attr(assigns[:active], @size, assigns[:disabled])} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp button_attr(active, size, disabled) do
    case disabled do
      true ->
        case size do
          "sm" ->
            [
              class:
                "border-b-4 border-transparent opacity-30 cursor-default px-2 pb-1 text-sm font-semibold"
            ]

          "lg" ->
            [
              class:
                "border-b-4 border-transparent opacity-30 cursor-default px-3 pb-1 text-base font-semibold"
            ]

          _ ->
            [
              class:
                "border-b-4 border-transparent opacity-30 cursor-default px-3 pb-1 text-base font-semibold"
            ]
        end

      _ ->
        case active do
          true ->
            case size do
              "sm" ->
                [
                  class:
                    "border-b-4 border-info px-2 pb-1 text-info text-sm cursor-default font-semibold"
                ]

              "lg" ->
                [
                  class:
                    "border-b-4 border-info px-3 pb-1 text-info cursor-default text-base font-semibold"
                ]

              _ ->
                [
                  class:
                    "border-b-4 border-info px-3 pb-1 text-info cursor-default text-base font-semibold"
                ]
            end

          _ ->
            case size do
              "sm" ->
                [
                  class:
                    "border-b-4 border-transparent px-2 pb-1 text-dark text-sm hover:text-info-primary font-semibold"
                ]

              "lg" ->
                [
                  class:
                    "border-b-4 border-transparent px-3 pb-1 text-dark text-base hover:text-info-primary font-semibold"
                ]

              _ ->
                [
                  class:
                    "border-b-4 border-transparent px-3 pb-1 text-dark text-base hover:text-info-primary font-semibold"
                ]
            end
        end
    end
  end

end

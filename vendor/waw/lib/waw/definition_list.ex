defmodule Waw.DefinitionList do
  @moduledoc """
    Afficher une liste de définitions.
  """

  use Phoenix.Component

  slot(:inner_block, required: true)

  @doc """
  Afficher la liste de definitions.

  ## Usage

  ```heex
    <.waw_dl>
      <.waw_definition term="term" description="description" text_align="left">
        <:actions>
          <.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
        </:actions>
      </.waw_definition>

      <.waw_definition term="term" description="description" text_align="left">
        <:actions>
          <.waw_link_icon size="sm" state="checked" icon="square-and-pencil" disabled/>
        </:actions>
      </.waw_definition>

      <.waw_definition term="term" description="description" text_align="left" />
    </.waw_dl>
  ```
  """

  def waw_dl(assigns) do
    ~H"""
    <dl class="flex flex-col space-y-px">
      {render_slot(@inner_block)}
    </dl>
    """
  end

  attr(:has_actions, :boolean, default: true)
  attr(:term, :string, doc: "Defines terms/names.")
  attr(:description, :string, default: "", doc: "Describes each term/name.")

  attr(:text_align, :string,
    doc: "Horizontal alignment of the content.",
    default: "left",
    values: ["left", "right"]
  )

  slot(:actions, doc: "Action button for edition.")
  slot(:inner_block, doc: "Description block.")

  @doc """
  Afficher l'élément de la definition.

  ## Usage
  ```heex
    <.waw_definition term="term" description="description" text_align="left">
      <:actions>
        <.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
      </:actions>
    </.waw_definition>
  ```
  """

  def waw_definition(assigns) do
    ~H"""
    <div class={[
      "flex flex-row items-center w-full space-x-1",
      text_align(@text_align)
    ]}>
      <div :if={@has_actions} class="flex items-center justify-center w-6 h-6">
        <div :if={assigns[:actions]}>
          {render_slot(@actions)}
        </div>
      </div>
      <div class="grow flex min-h-8 text-sm">
        <dt class="font-semibold">
          {@term}
        </dt>
        <span>
          &nbsp;:&nbsp;
        </span>
        <dd :if={@description} class="flex flex-wrap">
          {@description}
        </dd>
        <dd :if={render_slot(@inner_block)} class="flex flex-wrap">
          {render_slot(@inner_block)}
        </dd>
      </div>
    </div>
    """
  end

  defp text_align("left"), do: "justify-start"
  defp text_align("right"), do: "justify-end"
end

defmodule Waw.Tooltip do
  @moduledoc """
  Afficher une info-bulle.
  """

  use Phoenix.Component
  import Waw.Helpers

  @default_color "white"
  @default_position "top"
  @default_variant "simple"

  attr(:color, :string,
    default: "white",
    doc: "Color of component.",
    values: ~w(white black)
  )

  attr(:position, :string,
    default: "top",
    doc: "Position of component.",
    values:
      ~w(bottom_end bottom_start bottom left_end left_start left right_end right_start right top_end top_start top)
  )

  attr(:variant, :string,
    default: "simple",
    doc: "Variant.",
    values: ~w(arrow simple)
  )

  attr(:content, :string,
    default: "Information du tooltip.",
    doc: "Description of informations component."
  )

  slot(:inner_block, required: true)

  @doc """
  Afficher une info-bulle.

  ## Usage

  ```heex
  <.waw_tooltip position="top" color="white" content="Information du tooltip" margin="top" variant="simple">
    contenu
  </.waw_tooltip>
  ```
  """

  def tooltip(raw) do
    assigns =
      raw
      |> assign_new(:color, fn -> @default_color end)
      |> assign_new(:position, fn -> @default_position end)
      |> assign_new(:variant, fn -> @default_variant end)
      |> build_tooltip_attrs()

    ~H"""
    <div id={assigns[:id]} class="group relative inline-block">
      {render_slot(@inner_block)}
      <div {@tooltip_attrs}>
        <span :if={is_bitstring(@content)}>
          {@content}
        </span>
        <span :if={!is_bitstring(@content)}>
          {render_slot(@content)}
        </span>
      </div>
    </div>
    """
  end

  ### Tooltip Attrs ##########################

  defp build_tooltip_attrs(assigns) do
    class = build_class(~w(
      font-sans z-50 invisible opacity-0 group-hover:visible group-hover:opacity-100 absolute text-xs rounded shadow-md
      text-center whitespace-nowrap p-3 transition-all ease-in-out delay-150 duration-300
      #{classes(:color, assigns)}
      #{classes(:margin, assigns)}
      #{classes(:position, assigns)}
      #{classes(:variant, assigns)}
      #{Map.get(assigns, :extend_class)}
    ))

    attrs =
      assigns
      |> assigns_to_attributes([:color, :content, :id, :position, :variant])
      |> Keyword.put_new(:class, class)

    assign(assigns, :tooltip_attrs, attrs)
  end

  ### CSS Classes ##########################

  defp classes(:color, %{color: color}), do: "bg-#{color} text-#{color}-200"

  # Margin du tooltip par rapport au contenu
  defp classes(:margin, %{position: "bottom_end"}), do: "mt-1"
  defp classes(:margin, %{position: "bottom_start"}), do: "mt-1"
  defp classes(:margin, %{position: "bottom"}), do: "mt-1"
  defp classes(:margin, %{position: "left_end"}), do: "mr-3"
  defp classes(:margin, %{position: "left_start"}), do: "mr-3"
  defp classes(:margin, %{position: "left"}), do: "mr-3"
  defp classes(:margin, %{position: "right_end"}), do: "ml-3"
  defp classes(:margin, %{position: "right_start"}), do: "ml-3"
  defp classes(:margin, %{position: "right"}), do: "ml-3"
  defp classes(:margin, %{position: "top_end"}), do: "mb-1"
  defp classes(:margin, %{position: "top_start"}), do: "mb-1"
  defp classes(:margin, %{position: "top"}), do: "mb-1"

  # La position du tooltip
  defp classes(:position, %{position: "bottom_end"}), do: "top-full right-0"
  defp classes(:position, %{position: "bottom_start"}), do: "top-full left-0"

  defp classes(:position, %{position: "bottom"}),
    do: "top-full left-1/2 -translate-x-1/2"

  defp classes(:position, %{position: "left_end"}), do: "right-full bottom-0"
  defp classes(:position, %{position: "left_start"}), do: "right-full top-0"

  defp classes(:position, %{position: "left"}),
    do: "right-full top-1/2 -translate-y-1/2"

  defp classes(:position, %{position: "right_end"}), do: "left-full bottom-0"
  defp classes(:position, %{position: "right_start"}), do: "left-full top-0"

  defp classes(:position, %{position: "right"}),
    do: "left-full top-1/2 -translate-y-1/2"

  defp classes(:position, %{position: "top_end"}), do: "bottom-full right-0"
  defp classes(:position, %{position: "top_start"}), do: "bottom-full left-0"

  defp classes(:position, %{position: "top"}),
    do: "bottom-full left-1/2 -translate-x-1/2"

  # Variant
  defp classes(:variant, %{color: _color, position: position, variant: "arrow"}) do
    case position do
      pos when pos in ["bottom_end", "bottom_start", "bottom"] ->
        "after:absolute after:-top-1.5 after:left-1/2 after:-translate-x-1/2 after:border-solid after:border-b-8 after:border-x-transparent after:border-x-8 after:border-t-0 after:border-b-white"

      pos when pos in ["left_end", "left_start", "left"] ->
        "after:absolute after:-right-1.5 after:top-1/2 after:-translate-y-1/2 after:border-solid after:border-l-8 after:border-y-transparent after:border-y-8 after:border-r-0 after:border-l-white"

      pos when pos in ["right_end", "right_start", "right"] ->
        "after:absolute after:-left-1.5 after:top-1/2 after:-translate-y-1/2 after:border-solid after:border-r-8 after:border-y-transparent after:border-y-8 after:border-l-0 after:border-r-white"

      pos when pos in ["top_end", "top_start", "top"] ->
        "after:absolute after:-bottom-1.5 after:left-1/2 after:-translate-x-1/2 after:border-solid after:border-t-8 after:border-x-transparent after:border-x-8 after:border-b-0 after:border-t-white"
    end
  end

  defp classes(_rule_group, _assigns), do: nil
end

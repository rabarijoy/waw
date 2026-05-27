defmodule Waw.Badge do
  @moduledoc """
    Afficher badge
  """
  use Phoenix.Component

  import Waw.Helpers

  @default_color "info"

  @doc """
    Afficher le badge.

  ## Usage

  ```
    <.waw_badge label="value" color="success"/>
  ```
  """

  attr(:id, :string, required: true)

  attr(:color, :string,
    default: "success",
    doc: "The color of badge content",
    values: list_colors()
  )

  attr(:description, :string,
    default: "",
    doc: "The description of title"
  )

  attr(:scope, :string, doc: "The scope label")

  attr(:label, :string, doc: "The label", required: true)

  attr(:rest, :global, doc: "Arbitrary HTML or phx attributes")

  slot(:action)

  def waw_badge(
        %{
          label: _,
          scope: _
        } = raw
      ) do
    assigns =
      raw
      |> assign_new(:color, fn -> @default_color end)
      |> build_badge_attrs()

    ~H"""
    <div>
      <div
        class={assigns[:badge_attrs][:class_content_with_scope]}
        style={assigns[:badge_attrs][:style_content_with_scope]}
        id={@id}
        title={@description}
        {@rest}
      >
        <div
          class={assigns[:badge_attrs][:class_scope]}
          style={assigns[:badge_attrs][:style_scope]}
        >
          {@scope}
        </div>
        <div
          class={assigns[:badge_attrs][:class_label_with_scope]}
          style={assigns[:badge_attrs][:style_label_with_scope]}
        >
          {@label}
        </div>
        <div
          :if={render_slot(@action)}
          class={assigns[:badge_attrs][:class_action_with_scope]}
          style={assigns[:badge_attrs][:style_action_with_scope]}
        >
          {render_slot(@action)}
        </div>
      </div>
    </div>
    """
  end

  def waw_badge(raw) do
    assigns =
      raw
      |> assign_new(:color, fn -> @default_color end)
      |> build_badge_attrs()

    ~H"""
    <div>
      <div
        class={assigns[:badge_attrs][:class_content]}
        style={assigns[:badge_attrs][:style_content]}
        id={@id}
        title={@description}
        {@rest}
      >
        <div
          class={assigns[:badge_attrs][:class_label]}
          style={assigns[:badge_attrs][:style_label]}
        >
          {@label}
        </div>
        <div
          :if={render_slot(@action)}
          class={assigns[:badge_attrs][:class_action]}
          style={assigns[:badge_attrs][:style_label]}
        >
          {render_slot(@action)}
        </div>
      </div>
    </div>
    """
  end

  defp build_badge_attrs(assigns) do
    class_content_with_scope = build_class(~w(
      inline-flex overflow-hidden rounded-full border text-xs text-light shadow-sm flex items-center justify-center
        #{border(:color, assigns)}
      ))

    style_content_with_scope =
      build_style_with_color(
        assigns[:color],
        "border-color: #{assigns[:color]};"
      )

    class_scope = build_class(~w(
      inline-block align-middle px-1.5 flex items-center justify-center
        #{border(:color, assigns)}
        #{background(:color, assigns)}
      ))

    style_scope =
      build_style_with_color(
        assigns[:color],
        "background-color: #{assigns[:color]};"
      )

    class_content = build_class(~w(
        inline-flex overflow-hidden rounded-full border text-xs text-light shadow-sm flex items-center justify-center
        #{border(:color, assigns)}
        #{background(:color, assigns)}
      ))

    style_content =
      build_style_with_color(
        assigns[:color],
        "background-color: #{assigns[:color]}; border-color: #{assigns[:color]};"
      )

    class_label_with_scope = build_class(~w(
      inline-block px-1.5 align-middle flex items-center justify-center bg-light
        #{text(:color, assigns)}
      ))

    style_label_with_scope =
      build_style_with_color(assigns[:color], "color: #{assigns[:color]};")

    class_action_with_scope = build_class(~w(
      inline-block align-middle flex items-center justify-center hover:bg-light rounded-full w-4 h-4 flex items-center justify-center cursor-pointer
        #{text(:color, assigns)}
        #{background(:color, assigns)}
      ))

    style_action_with_scope =
      build_style_with_color(
        assigns[:color],
        "color: #{assigns[:color]}; background-color: #{assigns[:color]};"
      )

    class_action = build_class(~w(
      inline-block align-middle flex items-center justify-center bg-light hover:bg-light rounded-full w-4 h-4 flex items-center justify-center cursor-pointer
      #{text(:color, assigns)}
      ))

    style_action =
      build_style_with_color(assigns[:color], "color: #{assigns[:color]};")

    class_label = build_class(~w(
      inline-block align-middle px-1.5 flex items-center justify-center
        #{border(:color, assigns)}
        #{background(:color, assigns)}
      ))

    style_label =
      build_style_with_color(
        assigns[:color],
        "background-color: #{assigns[:color]}; border-color: #{assigns[:color]};"
      )

    attrs =
      assigns
      |> assigns_to_attributes([:color])
      |> Keyword.put_new(:class_content, class_content)
      |> Keyword.put_new(:class_content_with_scope, class_content_with_scope)
      |> Keyword.put_new(:class_scope, class_scope)
      |> Keyword.put_new(:class_action_with_scope, class_action_with_scope)
      |> Keyword.put_new(:class_label_with_scope, class_label_with_scope)
      |> Keyword.put_new(:class_label, class_label)
      |> Keyword.put_new(:class_action, class_action)
      |> Keyword.put_new(:style_content_with_scope, style_content_with_scope)
      |> Keyword.put_new(:style_scope, style_scope)
      |> Keyword.put_new(:style_label_with_scope, style_label_with_scope)
      |> Keyword.put_new(:style_content, style_content)
      |> Keyword.put_new(:style_action_with_scope, style_action_with_scope)
      |> Keyword.put_new(:style_label, style_label)
      |> Keyword.put_new(:style_action, style_action)

    assign(assigns, :badge_attrs, attrs)
  end

  defp border(:color, %{color: color}) do
    case Regex.match?(~r/#/, color) do
      true -> "border-[#{color}]"
      _ -> "border-#{color}"
    end
  end

  defp border(_rule_group, _assigns), do: nil

  defp background(:color, %{color: color}) do
    case Regex.match?(~r/#/, color) do
      true -> "bg-[#{color}]"
      _ -> "bg-#{color}"
    end
  end

  defp background(_rule_group, _assigns), do: nil

  defp text(:color, %{color: color}) do
    case Regex.match?(~r/#/, color) do
      true -> "text-[#{color}]"
      _ -> "text-#{color}"
    end
  end

  defp text(_rule_group, _assigns), do: nil
end

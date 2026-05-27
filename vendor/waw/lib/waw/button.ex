defmodule Waw.Button do
  @moduledoc """
    Afficher le bouton utilisé dans les applications Tag-IP.
  """
  import Waw.Icons
  import Waw.Helpers

  use Phoenix.Component

  attr(:label, :string)

  attr(:icon, :string,
    doc: "Icon name",
    values: Waw.Icons.icon_list()
  )

  attr(:icon_position, :string,
    default: "left",
    doc: "Icon position compared to the text",
    values: ~w(left right)
  )

  attr(:type, :string, default: "button", values: ~w(button submit cancel))

  attr(:size, :string,
    default: "md",
    doc: "The size of the component.",
    values: ~w(xs sm md lg)
  )

  attr(:full_width, :boolean,
    default: false,
    doc: "If true, the component will take up the full width of its container."
  )

  attr(:state, :string,
    default: "default",
    doc: "The state to use.",
    values: ~w(default checked unchecked)
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "The disabled button of component."
  )

  attr(:toggleable, :boolean,
    default: false,
    doc: "The toggleable button of component."
  )

  attr(:rest, :global,
    doc: "Arbitrary HTML or phx attributes",
    include:
      ~w(csrf_token disabled download form href hreflang method name navigate patch referrerpolicy rel replace target type value data)
  )

  # slot :inner_block, required: true

  @doc """
    Lister les types de bouton utilisés dans les applications Tag-IP.

  ## Usage

  ```
    <.waw_button label="Aujourd'hui" size="md" icon="calendar" icon_position="right" />
    <.waw_button label="Envoyer" size="md" type="submit" />
  ```
  """

  def waw_button(assigns) do
    ~H"""
    <button
      :if={assigns[:icon_position] == "right"}
      class={"flex items-center justify-center rounded-md font-sans tracking-wider focus:outline-none text-center transition duration-200 ease-in-out " <> check_attrs(@disabled, @state, @type) <> " " <> size_attr(@size) <> " " <> is_w_full(@full_width) <> " " <> is_toggleable(@toggleable)}
      type={@type}
      disabled={@disabled}
      {@rest}
    >
      <p
        :if={assigns[:label]}
        title={assigns[:label]}
        class={"truncate text-" <> @size}
      >
        {@label}
      </p>
      <span :if={assigns[:icon]} class="flex items-center justify-center ml-1">
        <.waw_icon name={@icon} size={icon_size(@size)} stroke="none" />
      </span>
    </button>

    <button
      :if={assigns[:icon_position] == "left"}
      class={"flex items-center justify-center rounded-md font-sans tracking-wider focus:outline-none text-center transition duration-200 ease-in-out " <> check_attrs(@disabled, @state, @type) <> " " <> size_attr(@size) <> " " <> is_w_full(@full_width) <> " " <> is_toggleable(@toggleable)}
      type={@type}
      disabled={@disabled}
      {@rest}
    >
      <span :if={assigns[:icon]} class="flex items-center justify-center mr-1">
        <.waw_icon name={@icon} size={icon_size(@size)} stroke="none" />
      </span>
      <p
        :if={assigns[:label]}
        title={assigns[:label]}
        class={"truncate text-" <> @size}
      >
        {@label}
      </p>
    </button>
    """
  end

  defp check_attrs(disabled, state, type) do
    case disabled do
      false ->
        case state do
          "default" ->
            case type do
              "button" ->
                "text-info border-info cursor-pointer bg-transparent hover:text-info-primary border border-solid hover:border-info-primary"

              "cancel" ->
                "text-dark border-dark cursor-pointer bg-transparent hover:text-info-primary border border-solid hover:border-info-primary"

              "submit" ->
                "text-info text-light border bg-info border-info cursor-default"

              _ ->
                "text-info border-info cursor-pointer bg-transparent hover:text-info-primary border border-solid hover:border-info-primary"
            end

          "checked" ->
            case type do
              "cancel" ->
                "text-dark border-dark cursor-pointer bg-transparent hover:text-info-primary border border-solid hover:border-info-primary"

              _ ->
                "text-info text-light border bg-info border-info cursor-default"
            end

          "unchecked" ->
            case type do
              "submit" ->
                "text-info text-light border bg-info border-info cursor-default"

              _ ->
                "text-dark border-dark cursor-pointer bg-transparent hover:text-info-primary border border-solid hover:border-info-primary"
            end
        end

      true ->
        case state do
          "default" ->
            case type do
              "submit" ->
                "text-light bg-default cursor-not-allowed"

              _ ->
                "text-default bg-transparent border border-solid border-default cursor-not-allowed"
            end

          "checked" ->
            case type do
              "cancel" ->
                "text-default bg-transparent border border-solid border-default cursor-not-allowed"

              _ ->
                "text-light bg-default cursor-not-allowed"
            end

          "unchecked" ->
            case type do
              "submit" ->
                "text-light bg-default cursor-not-allowed"

              _ ->
                "text-default bg-transparent border border-solid border-default cursor-not-allowed"
            end
        end

      _ ->
        "text-info border-info cursor-pointer bg-transparent hover:text-info-primary border border-solid hover:border-info-primary"
    end
  end

  # full_width
  defp is_w_full(value) do
    case value do
      true -> "w-full"
      _ -> "max-w-36"
    end
  end

  # toggeable
  defp is_toggleable(value) do
    case value do
      true -> "cursor-pointer"
      _ -> ""
    end
  end
end

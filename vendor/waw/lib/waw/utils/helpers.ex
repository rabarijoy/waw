defmodule Waw.Helpers do
  @moduledoc """
  Provides helper functionality.
  """
  alias Phoenix.{HTML.Form, LiveView.JS, LiveView.Socket}

  import Phoenix.Component

  require Logger

  @doc """
  Builds and normalizes list of classes.

  ## Examples

      iex> assign_class(assigns, [" class1", "class2 ", ...])
      %{class: "class1 class2 ...", ..}

  """
  @spec assign_class(Socket.assigns(), [String.t()]) :: Socket.assigns()
  def assign_class(assigns, []), do: assigns

  def assign_class(assigns, class_list) do
    assign_new(assigns, :class, fn ->
      if extend_class = Map.get(assigns, :extend_class) do
        [extend_class | Enum.reverse(class_list)]
        |> Enum.reverse()
        |> Enum.join(" ")
        |> String.trim()
      else
        class_list |> Enum.join(" ") |> String.trim()
      end
    end)
  end

  @doc """
  Builds and normalizes list of classes.

  ## Examples

      iex> assign_extend_class(assigns, [" class1", "class2 ", ...])
      %{class: "class1 class2 ...", ..}

  """
  @spec assign_extend_class(Socket.assigns(), [String.t()]) :: Socket.assigns()
  def assign_extend_class(assigns, []), do: assigns

  def assign_extend_class(assigns, extend_class_list) do
    extend_class =
      if extend_class = Map.get(assigns, :extend_class) do
        [extend_class | extend_class_list]
        |> Enum.reverse()
        |> Enum.join(" ")
        |> String.trim()
      else
        extend_class_list |> Enum.join(" ") |> String.trim()
      end

    assign(assigns, :extend_class, extend_class)
  end

  @doc """
  Builds and normalizes list of classes.

  ## Examples

      iex> assign_rest(assigns, exclude)
      %{...}

  """
  @spec assign_rest(Socket.assigns()) :: Socket.assigns()
  @spec assign_rest(Socket.assigns(), [atom()]) :: Socket.assigns()
  def assign_rest(assigns, exclude \\ []) do
    assign(assigns, :rest, assigns_to_attributes(assigns, exclude))
  end

  @doc """
  Builds and normalizes list of classes.

  ## Examples

      iex> build_class([" class1", "class2 ", ...])
      "class1 class2 ..."

  """
  @spec build_class([String.t()]) :: String.t()
  def build_class(class_list),
    do: class_list |> Enum.join(" ") |> String.trim()

  @doc """
  Returns true if assigns field form data has error.

  ## Examples

      iex> has_error(assigns)
      true

  """
  @spec has_error?(Socket.assigns()) :: boolean()
  def has_error?(%{field: field, form: %Form{} = f}),
    do: Keyword.has_key?(f.errors, field)

  def has_error?(_assigns), do: false

  @doc """
  Returns true if attr data is a slot.

  ## Examples

      iex> is_slot?(attrs)
      true

  """
  @spec is_slot?(any()) :: boolean()
  def is_slot?([%{__slot__: _} | _]), do: true
  def is_slot?(_params), do: false

  @error_message """
    Missing translate_error_module config. Add the following to your config/config.exs
    config :ui, translate_error_module: YourAppWeb.ErrorHelpers
  """

  @doc """
  Translates an error message using gettext.
  """
  def translate_error(error) do
    if module = Application.get_env(:ui, :translate_error_module) do
      module.translate_error(error)
    else
      # raise ArgumentError, message: @error_message
      Logger.error(@error_message)

      inspect(error)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  def check_color(color) do
    case Regex.match?(~r/#/, color) do
      true -> "[#{color}]"
      _ -> "#{color}"
    end
  end

  def build_style_with_color(color, style_list) do
    case Regex.match?(~r/#/, color) do
      true -> style_list
      _ -> ""
    end
  end

  def list_colors() do
    [
      "success",
      "success-primary",
      "info",
      "info-lite",
      "info-primary",
      "info-dark",
      "danger",
      "danger-primary",
      "danger-dark",
      "default",
      "default-lite",
      "default-primary",
      "default-dark",
      "light",
      "lite",
      "primary",
      "dark",
      "orange"
    ]
  end

  @doc """
  function size and icon size attributes from button and link components
  """
  def size_attr(size) do
    case size do
      "xs" -> "py-1.5 px-2 text-xs font-medium"
      "sm" -> "py-1 px-2 text-sm font-medium"
      "md" -> "py-1.5 px-2 text-sm font-medium"
      "lg" -> "p-2 text-base font-semibold"
      _ -> "py-1.5 px-2 text-sm font-medium"
    end
  end

  def icon_size(size) do
    case size do
      "lg" -> "5"
      "xs" -> "3"
      _ -> "4"
    end
  end
end

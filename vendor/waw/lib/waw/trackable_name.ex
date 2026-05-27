defmodule Waw.TrackableName do
  @moduledoc """
    Afficher un trackable.
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:value, :any,
    doc: "Informations",
    required: true
  )

  attr(:size, :string,
    default: "sm",
    doc: "The size of the text.",
    values: ~w(xs sm base lg)
  )

  attr(:with_symbol, :boolean, default: false)
  attr(:rest, :global)

  @doc """
  Afficher un trackable.

  ## Usage

  ```
    <.waw_name value={%{name: "4212TBA", custom_name: "ix35", label: "TGP0012", tracker_label: "MD0014"}} />
    <.waw_name size="sm" value={%{label: "TGP0012", name: "4212TBA", custom_name: "ix35", tracker_label: "MD0014", trackable_symbol: "car"}} with_symbol/>
  ```
  """

  def waw_name(assigns) do
    ~H"""
    <span title={title(@value)} class={"cursor-pointer text-" <> @size} {@rest}>
      <span :if={@with_symbol} class="mx-2">
        <.waw_icon
          :if={Map.get(@value, :trackable_symbol, false)}
          name={@value.trackable_symbol}
          size="4"
          stroke="none"
        />
        <.waw_icon
          :if={!Map.get(@value, :trackable_symbol, false)}
          name="car"
          size="4"
          stroke="none"
        />
      </span>
      {@value.name}
    </span>
    """
  end

  defp title(
         %{
           custom_name: custom_name,
           label: label,
           tracker_label: tracker_label
         } = _value
       ) do
    "#{custom_name} - #{label} - #{tracker_label}"
  end

  defp title(
         %{
           custom_name: custom_name,
           label: label
         } = _value
       ) do
    "#{custom_name} - #{label}"
  end

  defp title(
         %{
           custom_name: custom_name,
           tracker_label: tracker_label
         } = _value
       ) do
    "#{custom_name} - #{tracker_label}"
  end

  defp title(
         %{
           label: label,
           tracker_label: tracker_label
         } = _value
       ) do
    "#{label} - #{tracker_label}"
  end

  defp title(
         %{
           custom_name: custom_name
         } = _value
       ) do
    "#{custom_name}"
  end

  defp title(
         %{
           label: label
         } = _value
       ) do
    "#{label}"
  end

  defp title(
         %{
           tracker_label: tracker_label
         } = _value
       ) do
    "#{tracker_label}"
  end

  defp title(_value) do
    ""
  end
end

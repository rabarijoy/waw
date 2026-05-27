defmodule Waw.Footer do
  @moduledoc """
    Afficher le footer de Tag-IP.
  """
  use Phoenix.Component

  import Waw.Text.Dates

  @doc """
  Afficher le footer de Tag-IP.

  ## Usage

  ```
    <.waw_footer copyright_year={} />
  ```
  """
  attr(:copyright_year, :string, doc: "Année")
  attr(:local_time, :string, doc: "heure EAT")
  attr(:utc_time, :string, doc: "heure UTC")

  def waw_footer(assigns) do
    ~H"""
    <div class="text-sm md:text-base font-sans flex items-center justify-center shadow-inner bg-white w-full md:h-12">
      <div class="flex flex-row space-x-1">
        <div class="w-28 flex items-center justify-center">
          <span>&copy;&nbsp;Tag-IP&nbsp;</span>
          <span>{@copyright_year}</span>
        </div>
        <div :if={assigns[:local_time]}>
          <span class="w-auto flex items-center justify-center">
            <.time value={@local_time} format={:long} />
          </span>
        </div>
        <div :if={assigns[:utc_time]}>
          <span class="w-28 flex items-center justify-center">
            <.time value={@utc_time} format={:long} />
          </span>
        </div>
      </div>
    </div>
    """
  end

  @deprecated "Use `#{__MODULE__}.waw_footer/1`"
  defdelegate footer(assigns), to: __MODULE__, as: :waw_footer
end

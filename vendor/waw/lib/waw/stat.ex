defmodule Waw.Stat do
  @moduledoc """
    Une carte statistique affichant une valeur
  """
  use Phoenix.Component
  alias Waw.NumberHelper, as: N
  alias Waw.Text.DatesHelper, as: H
  import Waw.Icons

  attr(:title, :string, required: true)
  attr(:icon, :string, default: "info-circle-fill", values: icon_list())
  attr(:value, :string, doc: "Valeur à afficher")
  attr(:start_value, :string, doc: "Valeur à afficher")
  attr(:end_value, :string, default: nil, doc: "Valeur à afficher")
  attr(:col, :integer, default: 1, doc: "Nombre de colonne")
  attr(:is_clickable, :boolean, default: false)
  attr(:loading, :boolean, default: false)

  attr(:unit, :atom,
    default: nil,
    values: [nil | Cldr.Unit.known_units()]
  )

  attr(:previous_value, :integer, doc: "Ancienne valeur")
  attr(:previous_at, Datetime, doc: "Date et heure de l'ancienne valeur")

  attr(:variation_unit, :atom,
    default: nil,
    values: [nil, :percentage, :duration]
  )

  attr(:variation_symbol, :atom,
    default: :arrow,
    values: [
      :math,
      :arrow
    ]
  )

  attr(:status, :atom,
    default: :info,
    values: [:info, :success, :warning, :danger, :muted, :defective]
  )

  attr(:description, :string, default: "Aucune description disponible")
  attr(:total, :integer, doc: "Total à comparer avec la valeur")
  attr(:ratio, :atom, default: nil, values: [nil, :percentage])

  attr(:at, :any, doc: "Date et heure de la valeur")

  attr(:rest, :global)

  @doc """
  Afficher une carte statistique.

  ## Usage

  ```
    <.waw_stat
      total={251}
      unit={:kilometer}
      value={100}
      title="véhicules géolocalisés"
      icon="nom-inconnu" # utilisera "info-circle-fill" par défaut
    />
  ```

  Note : Si le nom de l'icône fourni n'existe pas, l'icône "info-circle-fill" sera affichée par défaut.
  """

  def waw_stat(assigns) do
    ~H"""
    <div
      class={"#{is_clickable(@is_clickable)} #{col_number(@col)} row-span-1 bg-white rounded-2xl bg-clip-border border border-gray-300"}
      {@rest}
    >
      <div
        :if={!@loading}
        class="relative flex flex-col min-w-0 break-words min-h-full text-dark"
      >
        <div class="flex-auto p-4">
          <div class="flex justify-between -mt-1 h-11">
            <div class={"#{text_color(@status)} inline-block"}>
              <.waw_icon name={@icon} stroke="none" size="6" />
            </div>
            <div :if={@status == :defective} class="inline-block text-danger">
              <.waw_icon name="exclamationmark-circle-fill" stroke="none" size="6" />
            </div>
          </div>
          <div class="flex-none max-w-full">
            <p class={"#{title_font(@status)} leading-normal text-xs sm:text-sm h-11 elipsis-card-title"}>
              {@title}
            </p>
          </div>
          <div class="grid h-10 place-content-start font-bold text-3xl w-full">
            <%= if assigns[:value] do %>
              <.stat_value
                :if={assigns[:value]}
                value={@value}
                unit={assigns[:unit]}
                total={assigns[:total]}
                ratio={assigns[:ratio]}
                status={assigns[:status]}
              />
            <% else %>
              {{:safe, "&mdash;"}}
            <% end %>
            <.stat_range_value
              :if={!assigns[:value] and assigns[:start_value]}
              start_value={@start_value}
              end_value={@end_value}
            />
          </div>
          <div
            :if={!!assigns[:value] and assigns[:previous_value]}
            class="h-8 grid place-content-start"
          >
            <.stat_variation
              value={@value}
              previous={assigns[:previous_value]}
              at={assigns[:previous_at]}
              symbol={assigns[:variation_symbol]}
            />
          </div>
        </div>
        <div :if={@description != ""} class="group relative">
          <div class="flex flex-col items-center relative mx-0.5">
            <div class="p-3 absolute bottom-0.5 z-10 bg-neutral-40 h-auto w-full rounded shadow-tooltip text-xs bg-white text-white-200 invisible opacity-0 group-hover:visible group-hover:opacity-100 shadow-md transition-all ease-in-out delay-150 duration-300 after:absolute after:-bottom-1.5 after:right-2 after:-translate-x-1/2 after:border-solid after:border-t-8 after:border-x-transparent after:border-x-8 after:border-b-0 after:border-t-white">
              <span>
                {@description}
              </span>
            </div>
          </div>
          <div class="flex flex-row items-end justify-between mt-2 w-full">
            <div class="p-4 pt-0">
              <.stat_at :if={assigns[:at]} at={assigns[:at]} />
            </div>
            <div class="p-4 pt-0" title={assigns[:description]}>
              <.waw_icon name="info-circle" size="4" stroke="none" />
            </div>
          </div>
        </div>
        <div
          :if={@status == :defective}
          class="bg-dark rounded h-1.5 lg:w-3/5 2xl:w-3/4 absolute bottom-5 left-4"
        />
      </div>
      <div
        :if={@loading}
        class="relative flex flex-col min-w-0 break-words min-h-full text-dark"
      >
        <div class="flex-auto p-4">
          <div class="flex justify-between -mt-1 h-11">
            <div class="text-dark inline-block">
              <.waw_icon name={@icon} stroke="none" size="6" />
            </div>
          </div>
          <div class="flex-none max-w-full">
            <p class="font-medium font-sans leading-normal text-xs sm:text-sm h-11 elipsis-card-title">
              {@title}
            </p>
          </div>
          <div
            class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-current border-r-transparent text-info align-[-0.125em] motion-reduce:animate-[spin_1.5s_linear_infinite]"
            role="status"
          >
            <span class="!absolute !-m-px !h-px !w-px !overflow-hidden !whitespace-nowrap !border-0 !p-0 ![clip:rect(0,0,0,0)]">
              Loading...
            </span>
          </div>
        </div>
        <div :if={@description != ""} class="group relative">
          <div class="flex flex-col items-center relative mx-0.5">
            <div class="p-3 absolute bottom-0.5 z-10 bg-neutral-40 h-auto w-full rounded shadow-tooltip text-xs bg-white text-white-200 invisible opacity-0 group-hover:visible group-hover:opacity-100 shadow-md transition-all ease-in-out delay-150 duration-300 after:absolute after:-bottom-1.5 after:right-2 after:-translate-x-1/2 after:border-solid after:border-t-8 after:border-x-transparent after:border-x-8 after:border-b-0 after:border-t-white">
              <span>
                {@description}
              </span>
            </div>
          </div>
          <div class="flex flex-col items-end mt-2">
            <div class="flex flex-col items-end p-4 pt-0">
              <.waw_icon name="info-circle" size="4" stroke="none" />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:start_value, :string, doc: "Valeur à afficher")
  attr(:end_value, :string, default: nil, doc: "Valeur à afficher")

  def stat_range_value(assigns) do
    ~H"""
    <p class="mb-2 font-bold">
      <.formatted_range_time
        :if={@end_value}
        start_value={@start_value}
        end_value={@end_value}
      />
      <.formatted_time :if={!@end_value} at={@start_value} />
      <span></span>
    </p>
    """
  end

  attr(:value, :string, doc: "Valeur à afficher")

  attr(:unit, :atom,
    default: nil,
    values: [nil | Cldr.Unit.known_units()]
  )

  attr(:total, :integer, doc: "Total à comparer avec la valeur")
  attr(:ratio, :atom, default: nil, values: [nil, :percentage])

  attr(:status, :atom,
    default: :info,
    values: [:info, :success, :warning, :danger, :muted, :defective]
  )

  def stat_value(%{value: value} = assigns) when is_number(value) do
    ~H"""
    <p class={"#{text_color(@status)} mb-2 font-bold"}>
      <.formatted_value :if={!@total} value={@value} unit={@unit} />
      <.stat_ratio :if={@total} value={@value} total={@total} ratio={@ratio} />
    </p>
    """
  end

  def stat_value(assigns) do
    ~H"""
    <p class="mb-2 font-bold">
      {@value}
    </p>
    """
  end

  attr(:at, :any, required: true)

  def stat_at(assigns) do
    ~H"""
    <span title={(not is_nil(@at) && DateTime.to_iso8601(@at)) || "N/A"}>
      <.formatted_time at={@at} />
    </span>
    """
  end

  def formatted_value(assigns) do
    ~H"""
    {N.number(@value, @unit)}
    """
  end

  def stat_ratio(%{ratio: :percentage, total: total} = assigns)
      when total > 0 do
    ~H"""
    <span title={"#{@value}/#{@total}"}>
      {N.number(@value / @total * 100, :percent)}
    </span>
    """
  end

  def stat_ratio(assigns) do
    ~H"""
    <span>{@value}</span><span class="text-default-lite">/<%= @total %></span>
    """
  end

  def formatted_time(assigns) do
    ~H"""
    {H.time_string(@at, format: :short)}
    """
  end

  def formatted_range_time(assigns) do
    ~H"""
    {H.interval(@start_value, @end_value, format: nil)}
    """
  end

  attr(:value, :string)
  attr(:previous, :integer)
  attr(:at, :any)
  attr(:ref, :any, default: DateTime.utc_now())

  attr(:unit, :atom,
    default: nil,
    values: [nil, :km, :kmh, :l, :l100, :duration]
  )

  attr(:symbol, :atom,
    default: :arrow,
    values: [
      :math,
      :arrow
    ]
  )

  def stat_variation(assigns) do
    ~H"""
    <p class="mb-0">
      <span class="font-bold leading-normal text-xs">
        <.variation_sign value={@value} previous={@previous} symbol={@symbol} />
        <.percent_variation value={@value} previous={@previous} />
      </span>
      <span
        :if={@at}
        class="font-semibold leading-normal text-xs text-default-lite"
      >
        {H.relative_time_string(@at, relative_to: @ref)}
      </span>
    </p>
    """
  end

  def percent_variation(assigns) do
    ~H"""
    <%= if @value > @previous do %>
      <span class="text-success" title={"#{@value}/#{@previous}"}>
        {N.number((@value - @previous) * 100 / @previous, :percent)}
      </span>
    <% else %>
      <span class="text-danger" title={"#{@value}/#{@previous}"}>
        {N.number((@previous - @value) * 100 / @value, :percent)}
      </span>
    <% end %>
    """
  end

  def variation_sign(%{symbol: :math} = assigns) do
    ~H"""
    <%= if @value > @previous do %>
      <span class="text-success">+</span>
    <% else %>
      <span class="text-danger">-</span>
    <% end %>
    """
  end

  def variation_sign(assigns) do
    ~H"""
    <%= if @value > @previous do %>
      <span class="text-success">
        <.waw_icon name="arrow-small-up" stroke="none" />
      </span>
    <% else %>
      <span class="text-danger">
        <.waw_icon name="arrow-small-down" stroke="none" />
      </span>
    <% end %>
    """
  end

  defp col_number(2), do: "col-span-2"
  defp col_number(_), do: ""

  defp is_clickable(true), do: "cursor-pointer hover:border-info"
  defp is_clickable(_), do: ""

  defp text_color(:success), do: "text-success"
  defp text_color(:danger), do: "text-danger"
  defp text_color(:muted), do: "text-default-lite"
  defp text_color(:defective), do: "text-dark"
  defp text_color(_), do: "text-dark"

  defp title_font(:defective), do: "font-bold font-sans"
  defp title_font(_), do: "font-medium font-sans"
end

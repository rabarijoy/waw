defmodule Waw.Dashboard do
  @moduledoc """
    Dashboard de tag-ip
  """
  use Phoenix.Component
  import Waw.Icons

  attr(:with_padding, :boolean, default: false)

  slot :section, doc: "Une section dans le tableau de bord" do
    attr(:title, :string, doc: "Titre de la section")
  end

  def waw_dashboard(assigns) do
    ~H"""
    <div class="relative flex flex-col h-full max-h-full overflow-x-auto no-scrollbar pb-2.5 lg:pb-6 w-full font-sans antialiased font-normal text-base leading-default bg-light text-slate-500">
      <div :for={section <- @section}>
        <h2
          :if={section[:title]}
          class="text-left font-sans font-semibold mt-4 mb-2 ml-5"
        >
          {section.title}
        </h2>
        <div class={"grid grid-flow-dense grid-auto-rows sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-4 #{p_class(@with_padding)}"}>
          {render_slot(section)}
        </div>
      </div>
    </div>
    """
  end

  slot(:tr)

  def waw_dashboard_table(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="items-center w-full mb-1 align-top border-collapse border-lite">
        <tbody>
          <tr :for={t <- @tr}>
            {render_slot(t)}
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  attr(:icon, :string)
  attr(:label, :string, default: "")
  attr(:value, :string, default: "")
  attr(:bordered, :boolean, default: false)

  def waw_dashboard_td(assigns) do
    ~H"""
    <td :if={assigns[:icon]} class={td_class(@bordered)}>
      <div class="flex items-center px-2 py-1">
        <div>
          <.waw_icon name="car" stroke="none" size="6" />
        </div>
        <div class="ml-6">
          <p class="mb-0 font-semibold leading-tight text-xs">
            {@label}
          </p>
          <h6 class="mb-0 leading-normal text-sm">{@value}</h6>
        </div>
      </div>
    </td>
    <td :if={!assigns[:icon]} class={td_class(@bordered)}>
      <div class="text-center">
        <p class="mb-0 font-semibold leading-tight text-xs">
          {@label}
        </p>
        <h6 class="mb-0 leading-normal text-sm">{@value}</h6>
      </div>
    </td>
    """
  end

  slot(:inner_block)

  def waw_dashboard_list(assigns) do
    ~H"""
    <div class="flex-auto px-4 pb-2 pt-1">
      <ul class="flex flex-col pl-0 mb-0 rounded-lg">
        {render_slot(@inner_block)}
      </ul>
    </div>
    """
  end

  attr(:item, :string, default: "")
  attr(:value, :string, default: "")

  def waw_dashboard_li(assigns) do
    ~H"""
    <li class="relative flex justify-between py-1.5 pr-4 border-0 rounded-t-lg rounded-xl text-inherit">
      <div class="flex items-center">
        <div class="inline-block w-8 h-8 mr-4 pt-1.5 text-center text-white bg-center shadow-sm fill-current stroke-none bg-gradient-to-tl from-zinc-800 to-zinc-700 rounded-xl">
          <.waw_icon name="car" stroke="none" />
        </div>
        <div class="flex flex-col -mt-1">
          <h6 class="mb-0 leading-normal text-sm text-slate-700">
            {@item}
          </h6>
          <span class="leading-tight text-xs">
            <span class="font-semibold">{@value}</span>
          </span>
        </div>
      </div>
    </li>
    """
  end

  defp td_class(true),
    do: "p-2 align-middle bg-transparent border-b whitespace-nowrap"

  defp td_class(_),
    do: "p-2 leading-normal align-middle bg-transparent border-0 text-sm whitespace-nowrap"

  defp p_class(false), do: "px-2 lg:px-4"
  defp p_class(_), do: "p-4"
end

defmodule Waw.Layouts.Layout3s do
  @moduledoc """
    Afficher une mise en page à 3 sections.
  """
  use Phoenix.Component

  slot(:header)
  slot(:subheader)
  slot(:filter_header)
  slot(:left_panel)
  slot(:main)
  slot(:details)
  slot(:right_panel)
  slot(:button_section)
  slot(:footer)

  @doc """
  Afficher le layout à 3 sections.

  ## Usage

  ```heex
    <.waw_layout_3s>
      <:header>
        ...
      </:header>
      <:left_panel>
        ...
      </:left_panel>
      <:main>
        ...
      </:main>
      <:details>
        ...
      </:details>
    </.waw_layout_3s>
  ```
  """

  def layout_3s(assigns) do
    ~H"""
    <div class="flex flex-col w-full h-screen max-h-screen">
      <div :if={assigns[:header]} class="flex-none w-full">
        {render_slot(@header)}
      </div>
      <div :if={assigns[:subheader]} class="flex-none">
        {render_slot(@subheader)}
      </div>
      <div :if={assigns[:filter_header]} class="flex-none">
        {render_slot(@filter_header)}
      </div>
      <%!-- content start --%>
      <div class="grow w-full overflow-y-auto no-scrollbar">
        <div class="flex flex-row h-full">
          <%!-- left start --%>
          <div
            :if={render_slot(@left_panel)}
            class="flex-none border-r w-80 shadow-sm h-full"
          >
            <div class="flex flex-col w-full h-full">
              {render_slot(@left_panel)}
            </div>
          </div>
          <%!-- left end --%>

          <%!-- center start --%>
          <div
            :if={!!render_slot(@main) and !!render_slot(@details)}
            class="grow h-full"
          >
            <div class="flex flex-wrap overflow-auto no-scrollbar h-1/2 p-2">
              {render_slot(@main)}
            </div>

            <div class="flex flex-col h-1/2">
              <div
                :if={render_slot(@button_section)}
                class="flex items-center w-full px-4 h-12"
              >
                {render_slot(@button_section)}
              </div>
              <div class="grow w-full overflow-y-auto no-scrollbar">
                {render_slot(@details)}
              </div>
            </div>
          </div>

          <div :if={!render_slot(@details)} class="grow h-full">
            <div class="flex flex-col h-full">
              <div
                :if={render_slot(@button_section)}
                class="flex items-center w-full px-4 h-12"
              >
                {render_slot(@button_section)}
              </div>
              <div class="flex flex-wrap overflow-auto no-scrollbar p-2">
                {render_slot(@main)}
              </div>
            </div>
          </div>

          <div :if={!render_slot(@main)} class="grow h-full">
            <div class="flex flex-col h-full">
              <div
                :if={render_slot(@button_section)}
                class="flex items-center justify-between w-full px-4 h-12"
              >
                {render_slot(@button_section)}
              </div>
              <div class="grow w-full overflow-y-auto no-scrollbar">
                {render_slot(@details)}
              </div>
            </div>
          </div>
          <%!-- center end --%>

          <%!-- right start --%>
          <div
            :if={render_slot(@right_panel)}
            class="flex-none border-l w-80 shadow-sm h-full"
          >
            <div class="flex flex-col w-full h-full">
              {render_slot(@right_panel)}
            </div>
          </div>
          <%!-- right end --%>
        </div>
      </div>
      <%!-- content end --%>
      <div :if={render_slot(@footer)} class="hidden lg:flex flex-none w-full h-12">
        {render_slot(@footer)}
      </div>
    </div>
    """
  end
end

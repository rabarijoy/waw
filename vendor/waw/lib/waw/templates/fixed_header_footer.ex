defmodule Waw.Templates.FixedHeaderFooter do
  @moduledoc """
  Template fixer le header et footer
  """
  use Phoenix.Component

  slot(:header, required: true)
  slot(:subheader)
  slot(:filter_header)
  slot(:main, required: true)
  slot(:footer)

  @doc """
  Afficher le template qui fixe le header et footer.

  ## Usage
  ```
  <.waw_fixed_header_footer>
    <:header>
      <.waw_header title="Démo" log_out_url="" profile_url="">
        <:nav>
          ...
        </:nav>
        <:actions>
          ...
        </:actions>
      </.waw_header>
    </:header>
    <:subheader>
      ...
    </:subheader>
    <:main>
      ...
    </:main>
    <:footer>
      <.waw_footer local_time="00:00:00" copyright_year="2023" utc_time="00:00:00" />
    </:footer>
  </.waw_fixed_header_footer>
  ```
  """

  def waw_fixed_header_footer(assigns) do
    ~H"""
    <div class="relative flex flex-col w-full h-screen max-h-screen">
      <div class="flex-none">
        {render_slot(@header)}
      </div>
      <div :if={assigns[:subheader]} class="flex-none">
        {render_slot(@subheader)}
      </div>
      <div :if={assigns[:filter_header]} class="flex-none">
        {render_slot(@filter_header)}
      </div>
      <div class="grow h-full max-h-full overflow-x-auto">
        {render_slot(@main)}
      </div>
      <div :if={assigns[:footer]} class="flex flex-none w-full h-12">
        {render_slot(@footer)}
      </div>
    </div>
    """
  end

  @deprecated "Use `waw_fixed_header_footer/1`"
  defdelegate fixed_header_footer(assigns),
    to: __MODULE__,
    as: :waw_fixed_header_footer
end

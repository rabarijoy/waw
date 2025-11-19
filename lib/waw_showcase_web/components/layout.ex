defmodule WawShowcaseWeb.Components.Layout do
  @moduledoc """
  Composants de layout pour le showcase.
  """
  use Phoenix.Component

  slot :inner_block, required: true

  def showcase_layout(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <WawShowcaseWeb.Components.Sidebar.sidebar />
      <main class="ml-64">
        <%= render_slot(@inner_block) %>
      </main>
    </div>
    """
  end
end

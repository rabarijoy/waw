defmodule WawShowcaseWeb.Components.Sidebar do
  @moduledoc """
  Composant sidebar pour la navigation dans le showcase.
  """
  use Phoenix.Component
  use Phoenix.VerifiedRoutes,
    endpoint: WawShowcaseWeb.Endpoint,
    router: WawShowcaseWeb.Router,
    statics: WawShowcaseWeb.static_paths()

  def sidebar(assigns) do
    ~H"""
    <aside class="fixed left-0 top-0 h-full w-64 bg-white border-r border-gray-200 shadow-sm z-10">
      <div class="p-6">
        <h2 class="text-2xl font-bold mb-6">Waw Components</h2>
        <nav class="space-y-2">
          <.link
            navigate={~p"/"}
            class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
          >
            Accueil
          </.link>
          <!-- Les liens vers les composants seront ajoutés dynamiquement -->
        </nav>
      </div>
    </aside>
    """
  end
end

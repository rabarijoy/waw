defmodule WawShowcaseWeb.Components.CodePreview do
  @moduledoc """
  Composant pour afficher un aperçu de code avec syntax highlighting.
  """
  use Phoenix.Component

  attr :code, :string, required: true, doc: "Le code à afficher"
  slot :inner_block, required: true, doc: "Le contenu à prévisualiser"

  def code_preview(assigns) do
    ~H"""
    <div class="mb-8">
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
        <div class="bg-gray-50 px-4 py-2 border-b border-gray-200">
          <span class="text-sm font-medium text-gray-700">Preview</span>
        </div>
        <div class="p-6">
          {render_slot(@inner_block)}
        </div>
      </div>
      <div class="mt-4 bg-gray-900 rounded-lg shadow-sm overflow-hidden">
        <div class="bg-gray-800 px-4 py-2 border-b border-gray-700">
          <span class="text-sm font-medium text-gray-300">Code</span>
        </div>
        <pre class="p-4 overflow-x-auto"><code class="text-sm text-gray-100"><%= @code %></code></pre>
      </div>
    </div>
    """
  end
end

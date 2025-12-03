defmodule WawShowcaseWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use WawShowcaseWeb, :html

  import Waw.Delegates

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div id="layout-root" phx-hook="ThemeManager" class="relative flex min-h-screen flex-col">
      <header class="navbar px-4 sm:px-6 lg:px-8">
        <div class="flex-1">
          <a href="/" class="flex flex-1 w-fit items-center gap-2">
            <img src={~p"/images/logo.svg"} width="36" />
            <span class="text-sm font-semibold">v{Application.spec(:phoenix, :vsn)}</span>
          </a>
        </div>
        <div class="flex-none">
          <ul class="flex flex-column items-center space-x-4 px-1">
            <li>
              <a href="https://phoenixframework.org/" class="btn btn-ghost">Website</a>
            </li>
            <li>
              <a href="https://github.com/phoenixframework/phoenix" class="btn btn-ghost">GitHub</a>
            </li>
            <li>
              <.theme_toggle />
            </li>
            <li>
              <a href="https://hexdocs.pm/phoenix/overview.html" class="btn btn-primary">
                Get Started <span aria-hidden="true">&rarr;</span>
              </a>
            </li>
          </ul>
        </div>
      </header>

      <main class="px-4 py-20 sm:px-6 lg:px-8">
        <div class="mx-auto max-w-2xl space-y-4">
          {render_slot(@inner_block)}
        </div>
      </main>

      <.flash_group flash={@flash} />

      <%!-- Popup de notification explicative du menu contextuel --%>
      <div
        id="context-menu-notification-popup"
        phx-hook="ContextMenuNotification"
        data-popup-delay="500"
        class="pointer-events-none fixed bottom-4 right-4 z-50 hidden opacity-0 transition-opacity duration-200"
      >
        <div data-component="Popup de notification">
          <.waw_notification_popup
            time=""
            description="Utilisez le clic droit importe-où"
            title="Menu-contextuel"
            icon="lightbulb"
          >
            <:show>
              <.waw_button_text label="Compris" data-context-menu-popup-button="dismiss" />
            </:show>
          </.waw_notification_popup>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  @doc """
  Layout avec navigation fixe pour les LiveViews (composant).
  Le header et le footer utilisent phx-update="ignore" pour ne pas être remplacés
  lors des mises à jour LiveView.
  """
  attr :current_page, :string,
    default: "",
    doc: "Page actuelle pour mettre en évidence le lien de navigation"

  slot :inner_block, required: true

  def app_with_nav(assigns) do
    ~H"""
    <.waw_fixed_header_footer>
      <:header>
        <div
          id="app-header"
          phx-update="ignore"
          data-component="waw_header"
          class="contents"
        >
          <.waw_header title="Waw Showcase" logout_url="" current_user_profile_url="">
            <:nav>
              <.waw_navbar
                active={@current_page == "/"}
                navigate={~p"/"}
                icon="speedometer"
                theme="light"
              >
                Tableau de bord
              </.waw_navbar>
              <.waw_navbar
                active={@current_page == "/vehicules"}
                navigate={~p"/vehicules"}
                icon="car"
                theme="light"
              >
                Véhicules
              </.waw_navbar>
              <.waw_navbar
                active={@current_page == "/carburant"}
                navigate={~p"/carburant"}
                icon="fuel-pump"
                theme="light"
              >
                Carburant
              </.waw_navbar>
              <.waw_navbar
                active={@current_page == "/rapports"}
                navigate={~p"/rapports"}
                icon="doc-text"
                theme="light"
              >
                Rapports
              </.waw_navbar>
              <.waw_navbar
                active={@current_page == "/reglages"}
                navigate={~p"/reglages"}
                icon="gearshape"
                theme="light"
              >
                Réglages
              </.waw_navbar>
            </:nav>
            <:actions>
              <div class="inline-flex items-center gap-2 mr-3">
                <div class="inline-flex rounded-full bg-gray-100 border border-gray-200 shadow-sm text-xs font-medium text-gray-600">
                  <button
                    type="button"
                    class="px-3 py-1 rounded-full bg-white text-gray-900 shadow-sm transition-colors duration-150 hover:bg-gray-50"
                  >
                    Demo
                  </button>
                  <button
                    type="button"
                    class="px-3 py-1 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150"
                  >
                    UI
                  </button>
                </div>
              </div>
              <.link>
                <.waw_icon name="bell-fill" size="4" />
              </.link>
              <.link>
                <.waw_icon name="circle-grid-3x3" size="4" />
              </.link>
              <.link>
                <.waw_icon name="person-fill" size="4" />
              </.link>
            </:actions>
          </.waw_header>
        </div>
      </:header>
      <:main>
        <div id="app-main" phx-update="replace">
          {render_slot(@inner_block)}
        </div>
      </:main>
      <:footer>
        <div
          id="app-footer"
          phx-update="ignore"
          data-component="waw_footer"
          class="contents"
        >
          <.waw_footer copyright_year={DateTime.utc_now().year} />
        </div>
      </:footer>
    </.waw_fixed_header_footer>
    """
  end

  # Helper pour préparer les composants depuis UIConfig pour l'affichage
  def prepare_components_for_display(category) do
    alias WawShowcase.UIConfig

    UIConfig.get_components_by_category(category)
    |> Enum.map(fn item ->
      # Créer une structure plate avec principal + variantes pour faciliter l'affichage
      %{
        sous_categorie: item.sous_categorie,
        nom: item.principal.nom,
        code_source: item.principal.code_source,
        variantes: item.variantes,
        # Pour la recherche et l'affichage
        search_key: String.downcase("#{item.sous_categorie} #{item.principal.nom}")
      }
    end)
  end

  # Helper pour rendre un composant depuis son code_source
  # Crée un module dynamique qui hérite des imports pour évaluer le template HEEx
  def render_component_preview(assigns) do
    code_source = Map.get(assigns, :code_source) || Map.get(assigns, "code_source")
    sous_categorie = Map.get(assigns, :sous_categorie) || Map.get(assigns, "sous_categorie")

    if code_source do
      try do
        template_code = String.trim(code_source)
        
        # Créer un module dynamique qui hérite des imports du module actuel
        module_name = :"DynamicPreview_#{:erlang.phash2({sous_categorie, template_code})}"
        
        # Définir le module dynamique avec tous les imports nécessaires
        module_code = """
        defmodule #{module_name} do
          use WawShowcaseWeb, :html
          import Waw.Delegates
          
          def render(assigns) do
            ~H\"\"\"
            #{template_code}
            \"\"\"
          end
        end
        """
        
        # Compiler et charger le module dynamique
        Code.eval_string(module_code, [], file: "dynamic_preview.ex", line: 1)
        
        # Appeler la fonction render du module dynamique
        result = apply(module_name, :render, [assigns])
        
        # Le résultat est déjà un %Phoenix.LiveView.Rendered{} struct
        result
      rescue
        exception ->
          # Logger l'erreur pour debug
          require Logger
          error_msg = Exception.message(exception)
          Logger.error("Erreur de rendu pour #{sous_categorie}: #{error_msg}")
          Logger.error("Stacktrace: #{inspect(__STACKTRACE__)}")
          Logger.error("Code source (200 premiers chars): #{String.slice(code_source, 0..200)}")
          assigns = assign(assigns, :error_msg, error_msg)
          ~H"""
          <div class="text-xs text-red-400 text-center p-2">
            Erreur: {@error_msg}
          </div>
          """
      end
    else
      ~H"""
      <div class="text-xs text-gray-400 text-center">Aperçu non disponible</div>
      """
    end
  end
end

defmodule WawShowcaseWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use WawShowcaseWeb, :html

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
end

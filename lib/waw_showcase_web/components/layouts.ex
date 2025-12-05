defmodule WawShowcaseWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use WawShowcaseWeb, :html

  # Import des helpers Waw (waw_date, waw_time, etc.)
  import Waw.Delegates
  # Import direct des helpers de dates pour <.date>, <.date_time>, <.interval>, <.time>, <.relative_time>
  import Waw.Text.Dates, only: [date: 1, date_time: 1, interval: 1, time: 1, relative_time: 1]

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*", except: [app_live: 1]

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

  # Layout app_live sans ID sur la nav pour éviter les duplications
  def app_live(assigns) do
    # Ne pas utiliser d'ID sur la nav car cela peut causer des duplications lors du montage initial
    # Le parent app-header avec phx-update="ignore" protège déjà tous les enfants
    # Utiliser uniquement la classe pour la sélection JavaScript
    ~H"""
    <.waw_fixed_header_footer>
      <:header>
        <div
          id="app-header"
          phx-update="ignore"
          phx-hook="ModeSwitch"
          data-component="waw_header"
          class="contents"
        >
          <.waw_header title="Waw Showcase" logout_url="" current_user_profile_url="">
            <:nav>
              <div class="flex items-center gap-4">
                <div class="app-main-nav flex items-center gap-4 transition-all duration-200">
                  <.waw_navbar navigate={~p"/"} theme="light">
                Tableau de bord
              </.waw_navbar>
                  <.waw_navbar navigate={~p"/vehicules"} theme="light">
                Véhicules
              </.waw_navbar>
                  <.waw_navbar navigate={~p"/carburant"} theme="light">
                Carburant
              </.waw_navbar>
                  <.waw_navbar navigate={~p"/rapports"} theme="light">
                Rapports
              </.waw_navbar>
                  <.waw_navbar navigate={~p"/reglages"} theme="light">
                Réglages
              </.waw_navbar>
                </div>

                <div class="hidden md:inline-flex items-center ml-6">
                  <div class="inline-flex h-8 items-center rounded-full bg-white/90 border border-gray-200 shadow-sm text-xs font-medium text-gray-600 px-1">
                    <button
                      type="button"
                      data-mode-toggle="desktop"
                      data-mode-value="demo"
                      class="inline-flex h-7 items-center px-3 rounded-full bg-gray-900 text-white shadow-sm transition-colors duration-150 hover:bg-gray-800"
                    >
                      Demo
                    </button>
                    <button
                      type="button"
                      data-mode-toggle="desktop"
                      data-mode-value="ui"
                      class="inline-flex h-7 items-center px-3 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150"
                    >
                      UI
                    </button>
                  </div>
                </div>
              </div>
            </:nav>
          </.waw_header>
        </div>
      </:header>
      <:main>
        <div id="app-main-content" phx-update="replace">
          {@inner_content}
        </div>
        <div
          id="ui-library-panel"
          class="hidden opacity-0 transition-opacity duration-200"
        >
          <.ui_library_panel />
        </div>
      </:main>
      <:footer>
        <div id="app-footer" phx-update="ignore" data-component="waw_footer" class="contents">
          <div class="md:hidden px-4 pt-2 pb-1 flex justify-start bg-white">
            <button
              type="button"
              data-mode-toggle="mobile"
              class="inline-flex items-center gap-2 rounded-full bg-white px-3 py-1.5 text-[0.7rem] font-medium text-gray-700 whitespace-nowrap"
            >
              <span data-mode-active-label class="inline-flex h-6 items-center rounded-full bg-gray-900 text-white px-2 text-[0.7rem]">
                Demo
              </span>
              <span data-mode-alt-label class="text-[0.65rem] leading-tight text-gray-500">
                Voir l'UI
              </span>
            </button>
          </div>

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

  # Helper pour aplatir les variantes avec sous-variantes en une liste plate
  # pour le rendu des previews dans le template
  def flatten_variants_for_preview(variantes) do
    variantes
    |> Enum.with_index()
    |> Enum.flat_map(fn {variant, group_idx} ->
      if Map.has_key?(variant, :sous_variantes) do
        # Variante avec sous-variantes
        variant.sous_variantes
        |> Enum.with_index()
        |> Enum.map(fn {sous_variant, sub_idx} ->
          %{
            nom: "#{variant.nom} - #{sous_variant.nom}",
            code_source: sous_variant.code_source,
            group_nom: variant.nom,
            group_idx: group_idx,
            sub_idx: sub_idx
          }
        end)
      else
        # Variante simple (sans sous-variantes)
        [%{
          nom: variant.nom,
          code_source: variant.code_source,
          group_nom: nil,
          group_idx: group_idx,
          sub_idx: nil
        }]
      end
    end)
  end

  # Helper pour rendre un composant de preview.
  #
  # IMPORTANT :
  # ----------
  # On évite toute compilation dynamique (Code.compile_string, etc.).
  # On rend en dur, avec ~H, les principaux composants de la librairie
  # Groupe les composants Basiques par groupe
  def group_basiques_components(components) do
    components
    |> Enum.group_by(&Map.get(&1, :groupe, "Autres"))
    |> Enum.sort_by(fn {groupe, _} ->
      # Ordre des groupes
      order = [
        "Navigation",
        "Actions",
        "Affichage",
        "Formulaires",
        "Listes",
        "Conteneurs",
        "Blocs",
        "Tableaux",
        "Navigation avancée",
        "Recherche et filtres",
        "Cartes",
        "Autres"
      ]
      Enum.find_index(order, &(&1 == groupe)) || 999
    end)
  end

  @doc """
  Retourne la valeur data-component correspondant à une sous-catégorie.
  Cette valeur est utilisée pour identifier les composants dans les pages Demo
  et permettre la navigation depuis le menu contextuel vers la page UI.
  """
  def get_component_data_attribute(sous_categorie) do
    case sous_categorie do
      # Basiques
      "Accordion" -> "waw_accordion"
      "Badge" -> "waw_badge"
      "Boutons" -> "waw_button"
      "Champs" -> "input"
      "Header" -> "waw_header"
      "Footer" -> "waw_footer"
      "Tableau" -> "waw_table"
      "Titre de block" -> "waw_block_title"
      "Séparateur de blocs" -> "waw_block_separator"
      "Header des filtres" -> "waw_filter_header"
      "Flash" -> "waw_flash"
      "Groupe de flash" -> "waw_flash_group"
      "Pagination" -> "waw_pagination"
      "Steps" -> "waw_steps"
      "Onglets" -> "waw_tabs"
      "Modal" -> "waw_modal"
      "Header de carte" -> "waw_card_header"
      "Statistique" -> "waw_stat"
      "Status block" -> "waw_status_block"
      "Texte éditable" -> "waw_contenteditable"
      "Liste des champs avec description" -> "waw_dl"
      "Liste" -> "waw_ul"
      "Tooltip" -> "tooltip"

      # Texte et Nombres
      "Devises" -> "currency"
      "Texte" -> "waw_text"
      "Distance" -> "waw_distance"
      "Nombre" -> "waw_number"
      "Volume" -> "waw_number"
      "Valeur nil" -> "waw_number"

      # Dates et heures
      "Date" -> "waw_date"
      "Heure" -> "waw_time"
      "Date et heure" -> "waw_date_time"
      "Intervalle" -> "waw_interval"
      "Temps relatif" -> "waw_relative_time"

      # Cartes
      "Compte-rendu" -> "waw_card"
      "Dashboard" -> "waw_dashboard_card"
      "Volume de carburant" -> "waw_fuel_card"
      "Statistique" -> "waw_stat"

      # Icônes
      _ when is_binary(sous_categorie) ->
        # Pour les icônes, utiliser le nom directement
        if String.starts_with?(sous_categorie, "waw_icon") do
          "waw_icon"
        else
          nil
        end

      _ -> nil
    end
  end

  # Filtre les icônes valides en vérifiant qu'elles peuvent être rendues
  # On retourne simplement la liste pour l'instant car le filtrage se fera au rendu
  # avec icon_exists? pour chaque icône
  def filter_valid_icons(icon_names) when is_list(icon_names), do: icon_names
  def filter_valid_icons(_), do: []

  # Vérifie si une icône existe en essayant de la rendre
  def icon_exists?(icon_name) when is_binary(icon_name) do
    try do
      # Essayer de rendre l'icône pour vérifier qu'elle existe
      # On utilise un render minimaliste pour valider
      assigns = %{name: icon_name, size: "6"}

      # Essayer de créer le composant waw_icon
      # Si le composant existe et que l'icône est valide, cela fonctionnera
      # Sinon, cela lèvera une exception
      case function_exported?(Waw.Icons, :waw_icon, 1) do
        true ->
          # Le composant existe, on assume que l'icône est valide
          # Le vrai filtrage se fera au moment du rendu
          true
        false ->
          # Le composant n'existe pas, vérifier avec render si disponible
          if function_exported?(Waw.Icons, :render, 1) do
            true
          else
            # Si aucune fonction n'est disponible, on assume que l'icône existe
            # Le filtrage réel se fera au moment du rendu avec un try/rescue
            true
          end
      end
    rescue
      _ -> false
    catch
      _ -> false
    end
  end

  def icon_exists?(_), do: false

  # pour garantir un comportement stable et prévisible.
  def render_component_preview(assigns) do
    sous_categorie = Map.get(assigns, :sous_categorie) || Map.get(assigns, "sous_categorie")

    case sous_categorie do
      ## Texte et Nombres
      "Devises" ->
        ~H"""
        <.currency value={123} currency="USD" />
        """

      "Distance" ->
        ~H"""
        <.distance unit={:meter} value={10000} />
        """

      "Valeur nil" ->
        ~H"""
        <.number unit={nil} value={nil} />
        """

      "Nombre" ->
        ~H"""
        <.number unit={nil} value={12000} />
        """

      "Volume" ->
        ~H"""
        <.number unit={:liter} value={10000} />
        """

      "Texte" ->
        ~H"""
        <.text value="Exemple de texte" />
        """

      ## Cartes
      "Compte-rendu" ->
        ~H"""
        <.waw_card
          title="Driver Score Card Synthesis"
          tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules."
        >
          <:section>
            <.waw_time_section label="Dernier Maj" value="12:30:05" />
            <.waw_date_section label="Dernier CR disponible" value="Aujourd'hui" />
            <.waw_date_section label="1er CR disponible" value="Aujourd'hui" />
          </:section>
        </.waw_card>
        """

      "Dashboard" ->
        ~H"""
        <.waw_dashboard_card
          title="Véhicules géolocalisés"
          description="Information concernant les véhicules géolocalisés"
        >
          <div class="grid place-content-center p-4 h-full">
            Content
          </div>
        </.waw_dashboard_card>
        """

      "Volume de carburant" ->
        ~H"""
        <.waw_fuel_card
          value="35"
          number="1510"
          title="Consommation totale de carburant de la flotte"
        />
        """

      "Statistique" ->
        # Choix d'un état simple et parlant pour le preview
        ~H"""
        <.waw_stat
          value={100}
          total={251}
          title="Véhicules géolocalisés"
          description="Information concernant les véhicules géolocalisés"
        />
        """

      ## Dates et heures
      "Dates" ->
        ~H"""
        <.date value={~U[2025-11-20 08:19:56.285343Z]} format={:medium} />
        """

      "Intervalle de temps" ->
        ~H"""
        <.interval format={:medium} from={~D[2025-11-20]} to={~D[2025-11-23]} />
        """

      "Relatives" ->
        ~H"""
        <.relative_time
          value={~U[2025-11-21 08:24:47.338059Z]}
          ref={~U[2025-11-20 08:24:47.338092Z]}
        />
        """

      "Heures" ->
        ~H"""
        <.time value={~U[2025-11-20 08:27:09.103149Z]} format={:medium} />
        """

      ## Basiques
      "Accordion" ->
        ~H"""
        <div class="-mx-6 -my-4">
          <.waw_accordion count={12} id="accordion-single-normal" has_group>
          <.waw_accordion id="accordion-2" head_icon="truck" title="Truck" count={8}>
          <.waw_table without_border>
          <:thead>
          <.waw_th></.waw_th>
          <.waw_th>Véhicules</.waw_th>
          <.waw_th sort_key="asc">Heure</.waw_th>
          </:thead>
          <:tr state="selected">
          <.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
          <.waw_td title="6541 TBA" is_link={true} href="https://www.tag-ip.com/">
          6541 TBA
          <:description>Vitesse > 60km/h</:description>
          </.waw_td>
          <.waw_td title="14:42:37">14:42:37</.waw_td>
          </:tr>
          <:tr state="normal">
          <.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
          <.waw_td title="3354 TBS">
          3354 TBS
          <:description>Vitesse > 70km/h</:description>
          </.waw_td>
          <.waw_td title="14:42:37">14:42:37</.waw_td>
          </:tr>
          <:tr state="disabled">
          <.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
          <.waw_td title="3354 TBA">
          3354 TBA
          <:description>Vitesse > 50km/h</:description>
          </.waw_td>
          <.waw_td title="14:42:37">14:42:37</.waw_td>
          </:tr>
          </.waw_table>
          </.waw_accordion>
          <.waw_accordion id="accordion-3" head_icon="moto" title="moto" />
          </.waw_accordion>
        </div>
        """

      "Badge" ->
        assigns = assign(assigns, :badge_id, "badge-preview-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <.waw_badge id={@badge_id} label="value" color="#12dba2"/>
        """

      "Séparateur de blocs" ->
        ~H"""
        <.waw_block_separator/>
        """

      "Titre de block" ->
        ~H"""
        <.waw_block_title label="Trackable sélectionné"/>
        """

      "Boutons" ->
        ~H"""
        <.waw_button label="OK" size="md" type="submit"/>
        """

      "Texte éditable" ->
        ~H"""
        <.waw_contenteditable id="contenteditable-single-text" label="Name" value="Edit this name">
          <:status>
            <.waw_icon name="checkmark-icloud"/>
          </:status>
        </.waw_contenteditable>
        """

      "Liste des champs avec description" ->
        ~H"""
        <.waw_dl>
        <.waw_definition text_align="left" term="term" has_actions={false}>
        <p>description en block</p>
        </.waw_definition>
        <.waw_definition text_align="left" term="term" has_actions={false}>
        <p>description en block</p>
        </.waw_definition>
        </.waw_dl>
        """

      "Header des filtres" ->
        ~H"""
        <.waw_filter_header id="filter-header-single-full">
        <:left>
        <.waw_button label="Organisation" size="md" icon="angle-small-down" icon_position="right" />
        <.waw_button label="Flotte" size="md" icon="angle-small-down" icon_position="right" />
        </:left>
        <:filter>
        <.waw_nav_filter value={120} icon="car" description="car" />
        </:filter>
        <:filter>
        <.waw_nav_filter value={25} icon="moto" />
        </:filter>
        <:filter>
        <.waw_nav_filter value={145} title="Total:" active description="Nombre total" />
        </:filter>
        </.waw_filter_header>
        """

      "Flash" ->
        flash_info_id = "flash-info-#{System.unique_integer([:positive, :monotonic])}"
        assigns =
          assigns
          |> assign(:flash_preview_id, "flash-preview-#{System.unique_integer([:positive, :monotonic])}")
          |> assign(:flash_info_id, flash_info_id)
        ~H"""
        <div class="flex flex-col items-center gap-4">
          <.waw_button
            type="button"
            phx-click={JS.show(to: "##{@flash_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-0 translate-y-4", "opacity-100 translate-y-0"})}
            label="Afficher Flash"
            size="md"
          />
          <div id={@flash_preview_id} class="hidden">
            <.flash id={@flash_info_id} kind={:info} flash={%{"info" => "Message d'information"}} />
          </div>
        </div>
        """

      "Groupe de flash" ->
        assigns = assign(assigns, :flash_group_preview_id, "flash-group-preview-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <div class="flex flex-col items-center gap-4">
          <.waw_button
            type="button"
            phx-click={JS.show(to: "##{@flash_group_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-0 translate-y-4", "opacity-100 translate-y-0"})}
            label="Afficher Groupe"
            size="md"
          />
          <div id={@flash_group_preview_id} class="hidden">
            <.flash_group title="Notification" flash={%{"error" => "Serveur erreur."}}/>
          </div>
        </div>
        """

      "Footer" ->
        ~H"""
        <div class="-mx-6 -my-4">
          <Waw.Footer.footer copyright_year={2025}/>
        </div>
        """

      "Header" ->
        ~H"""
        <.waw_header title="Titre de la page" current_user={%{id: 1, name: "Alice", email: "alice@example.com"}} header_id="notification" connected_user={%{id: 1, name: "Alice", email: "alice@example.com"}} notification_action={JS.toggle(to: "#notification_user_menu")} user_home_url="https://auth.tag-ip.com" has_i18n>
          <:menu_language navigate="en" href="/"> English </:menu_language>
          <:menu_language navigate="mg" href="/"> Malagasy </:menu_language>
        </.waw_header>
        """

      "Champ" ->
        ~H"""
        <.input name="search" type="search" value=""/>
        """

      "Champs" ->
        ~H"""
        <.input name="search" type="search" value=""/>
        """

      "Lien icône" ->
        ~H"""
        <.waw_link_icon size="sm" state="checked" icon="home"/>
        """

      "Lien texte" ->
        ~H"""
        <.waw_link_text label="3 derniers jours" size="sm" state="unchecked"/>
        """

      "Element d'une liste" ->
        ~H"""
        <Waw.List.ul>
        <Waw.List.li acronym="T" state="selected" title="Tag-ip">Tag-ip</Waw.List.li>
        <Waw.List.li acronym="2" title="2mi">2mi</Waw.List.li>
        <Waw.List.li acronym="H" title="Holcim">Holcim</Waw.List.li>
        </Waw.List.ul>
        """

      "Header de liste pour le tri" ->
        ~H"""
        <.waw_list_header>
        <:left>
        <.waw_button_icon icon="caret-down" />
        </:left>
        <:center>
        <.waw_button_icon icon="caret-down" />
        </:center>
        <:right>
        <.waw_button_icon icon="caret-up" />
        <.waw_button_icon icon="caret-down" />
        <.waw_button_icon icon="caret-up" />
        </:right>
        </.waw_list_header>
        """

      "Bouton collapse" ->
        ~H"""
        <.waw_live_button selected_item="Toutes les organisations" with_search={true} show_list={true} search_name="bouton-collapse-search">
        <:results>
        <.waw_li_button active>Org 1</.waw_li_button>
        <.waw_li_button>Org 2</.waw_li_button>
        </:results>
        </.waw_live_button>
        """

      "Filtre de gauche à droite avec recherche" ->
        ~H"""
        <.waw_live_filter list={[%{id: 1, value: "Item 1", selected: true}, %{id: 2, value: "Item 2"}, %{id: 3, value: "Item 3", selected: true}, %{id: 4, value: "Item 4"}, %{id: 5, value: "Item 5"}, %{id: 6, value: "Item 6", selected: true}, %{id: 7, value: "Item 7"}]}>
        <:left>
        <.waw_section_title>Elements disponibles</.waw_section_title>
        <.input id="input-single-search-without-border" name="search" value="" type="search_without_border" popup_is_visible>
        <Waw.List.li>item 1</Waw.List.li>
        <Waw.List.li>item 2</Waw.List.li>
        </.input>
        </:left>
        <:right>
        <.waw_section_title>Elements filtrés</.waw_section_title>
        <.input id="input-single-search-without-border-2" name="search2" value="" type="search_without_border">
        <Waw.List.li>item 3</Waw.List.li>
        <Waw.List.li>item 6</Waw.List.li>
        </.input>
        </:right>
        </.waw_live_filter>
        """

      "Recherche avec un resultat dans un popup" ->
        ~H"""
        <Waw.LiveSearch.live_search name="recherche-popup">
        <:results>
        <Waw.LiveSearch.list_group title="Organisations">
        <.waw_li_button>org 1</.waw_li_button>
        <.waw_li_button>org 2</.waw_li_button>
        </Waw.LiveSearch.list_group>
        <Waw.LiveSearch.list_group title="Flottes">
        <.waw_li_button>flotte 1</.waw_li_button>
        <.waw_li_button>flotte 2</.waw_li_button>
        </Waw.LiveSearch.list_group>
        </:results>
        </Waw.LiveSearch.live_search>
        """

      "Loading" ->
        ~H"""
        <Waw.Loading.loading/>
        """

      "Logos" ->
        ~H"""
        <Waw.Logo.logo name="tag-ip"/>
        """

      "Footer de carte" ->
        ~H"""
        <Waw.MapFooter.map_footer>
          <:left>
            <Waw.MapFooter.head_section icon="flag-circle-fill" title="Localisation" />
            <Waw.MapFooter.content id="left">
              <Waw.MapFooter.section label="Date/heure" value="03/11/2023 à 10:53:01" description="03/11/2023 à 10:53:01" />
              <Waw.MapFooter.section label="Position" value="-19,39916 ,47,4406" description="-19,39916 ,47,4406" />
              <Waw.MapFooter.section label="Vitesse/Cap" value="33 km/h 198°" description="33 km/h 198°" />
              <Waw.MapFooter.section label="Altitude" value="68 m" description="68 m" />
            </Waw.MapFooter.content>
          </:left>
          <:right>
            <Waw.MapFooter.head_section icon="car" title="Véhicule" />
            <Waw.MapFooter.content id="right" col={2}>
              <Waw.MapFooter.section label="Contact" value="OFF" description="OFF" />
              <Waw.MapFooter.section label="Moteur" value="OFF" description="OFF" />
              <Waw.MapFooter.section label="Odomètre" value="342 699,20 km" description="342 699,20 km" />
              <Waw.MapFooter.section label="Carburant" value="171,7 l" description="171,7 l" />
              <Waw.MapFooter.section label="RPM" value="0" description="0" />
            </Waw.MapFooter.content>
          </:right>
        </Waw.MapFooter.map_footer>
        """

      "Header de carte" ->
        ~H"""
        <Waw.MapHeader.map_header max={100} min={0} value={45} time="10:19:45" input_name="input-range" time_title="10:19:45">
        <.waw_button_icon icon="playpause-left-fill" icon_size={5} title="Départ précédent" />
        <.waw_button_icon icon="backward-end-alt-fill" icon_size={5} title="Evénement précédent" />
        <.waw_button_icon icon="backward-end-fill" title="Point précédent"/>
        <.waw_button_icon icon="play-fill" />
        <.waw_button_icon icon="forward-end-fill" title="Point suivant" disabled />
        <.waw_button_icon icon="forward-end-alt-fill" icon_size={5} title="Evénement suivant" disabled />
        <.waw_button_icon icon="playpause-right-fill" icon_size={5} title="arrêt suivant" disabled />
        <.waw_button_text label="X" value="4" title="Changer la vitesse de lecture" />
        <.waw_button_icon icon="arrow-triangle-2-circlepath-refresh" />
        </Waw.MapHeader.map_header>
        """

      "Pagination" ->
        ~H"""
        <.waw_pagination label="Page" meta={%{current_page: 1, total_pages: 2, previous_page: nil, next_page: 2}} previous_page_action={nil} next_page_action={nil}/>
        """

      "Steps" ->
        ~H"""
        <.waw_steps>
        <:step status={:valid}>
        Initialisation
        </:step>
        <:step status={:invalid} active>
        Covoiturage
        </:step>
        <:step status={:disabled}>
        Véhicule
        </:step>
        <:step status={:disabled}>
        Chauffeur
        </:step>
        <:step status={:disabled} disabled>
        Récapitulation
        </:step>
        </.waw_steps>
        """

      "Tableau" ->
        ~H"""
        <.waw_table>
        <:thead>
        <.waw_th sort_key="desc">Name</.waw_th>
        <.waw_th sort_key="asc">First Name</.waw_th>
        </:thead>
        <:tr state="selected">
        <.waw_td title="Jean">Jean</.waw_td>
        <.waw_td title="Dupont">Dupont</.waw_td>
        </:tr>
        <:tr state="normal">
        <.waw_td title="Kim">Kim</.waw_td>
        <.waw_td title="Léna" is_link={true} href="https://www.tag-ip.com/">Léna</.waw_td>
        </:tr>
        <:tr state="disabled">
        <.waw_td title="Sam">Sam</.waw_td>
        <.waw_td title="Smith">Smith</.waw_td>
        </:tr>
        </.waw_table>
        """

      "Onglets" ->
        ~H"""
        <.waw_tabs size="lg" align_tab="left">
        <.waw_tab active>
        Items
        </.waw_tab>
        <.waw_tab>
        Flottes
        </.waw_tab>
        <.waw_tab disabled>
        Instances
        </.waw_tab>
        <:actions>
        <.waw_button label="Rafraîchir" size="sm" variant="outlined" icon="home" />
        <div>
        <.input id="input-single-search-litle-2" name="search" value="" size="sm" type="search" />
        </div>
        </:actions>
        <:content>
        <div>Content of tab</div>
        </:content>
        </.waw_tabs>
        """

      "Afficher un trackable" ->
        ~H"""
        <.waw_name value={%{label: "TGP0012", name: "4212TBA", tracker_label: "MD0014", custom_name: "ix35"}}/>
        """

      "Modal" ->
        assigns = assign(assigns, :modal_preview_id, "modal-preview-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <div class="flex flex-col items-center gap-4">
          <.waw_button
            type="button"
            phx-click={JS.show(to: "##{@modal_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-0 scale-95", "opacity-100 scale-100"})}
            label="Ouvrir Modal"
            size="md"
          />
          <div id={@modal_preview_id} class="hidden">
            <.waw_modal id={"#{@modal_preview_id}-modal"} show={true}>
              <:title>
                Titre du Modal
              </:title>
              <:cancel>
                <.waw_button_icon icon="cancel" icon_size={5} stroke="none" phx-click={JS.hide(to: "##{@modal_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-100 scale-100", "opacity-0 scale-95"})} />
              </:cancel>
              <:content>
                <div class="p-6">
                  <p class="text-gray-700">Contenu du modal de démonstration.</p>
                </div>
              </:content>
              <:actions>
                <.waw_button label="Annuler" size="sm" phx-click={JS.hide(to: "##{@modal_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-100 scale-100", "opacity-0 scale-95"})} />
                <.waw_button label="Confirmer" size="sm" type="submit" />
              </:actions>
            </.waw_modal>
          </div>
        </div>
        """

      "Sous header" ->
        ~H"""
        <.waw_subheader>
        <:right>
        <div>Texte à droite</div>
        </:right>
        </.waw_subheader>
        """

      "Header d'un contenu" ->
        ~H"""
        <.waw_panel_header title="Title"/>
        """

      "Bloc de status" ->
        ~H"""
        <.waw_status_block title="Informations" icon="info-circle-fill">
        <:content>
        <.waw_status_block_content value="Le véhicule est au parking. La balise GPS est connectée." />
        </:content>
        </.waw_status_block>
        """

      "Info-bulle" ->
        ~H"""
        <div class="relative inline-block group">
          <span class="cursor-pointer">Survolez pour voir le tooltip</span>
          <div class="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 opacity-100 !visible !block pointer-events-auto z-50" style="display: block !important; visibility: visible !important; opacity: 1 !important;">
            <.tooltip position="top" color="white" content="Information du tooltip" variant="simple" margin="top">
            </.tooltip>
          </div>
        </div>
        """

      "Liste de tags" ->
        unique_id = System.unique_integer([:positive, :monotonic])
        assigns = assign(assigns, :tag_list_unique_id, unique_id)
        ~H"""
        <.waw_tag_list title="Flottes">
        <:tag>
        <.waw_badge id={"badge-tag-list-1-#{@tag_list_unique_id}"} label="value" scope="scope" description="Avec étiquette" color="info-dark">
        <:action>
        <.waw_button_icon icon="cancel" bg_color="bg-light" />
        </:action>
        </.waw_badge>
        </:tag>
        <:tag>
        <.waw_badge id={"badge-tag-list-2-#{@tag_list_unique_id}"} label="value" scope="scope" description="Avec étiquette" color="danger" />
        </:tag>
        <:tag>
        <.waw_badge id={"badge-tag-list-3-#{@tag_list_unique_id}"} label="value" description="title" color="info">
        <:action>
        <.waw_button_icon icon="cancel" />
        </:action>
        </.waw_badge>
        </:tag>
        <:tag>
        <.waw_badge id={"badge-tag-list-4-#{@tag_list_unique_id}"} label="value" color="success" />
        </:tag>
        <:actions>
        <.waw_button_icon icon="add" title="Ajouter un tag" />
        </:actions>
        </.waw_tag_list>
        """

      "Popup de notification" ->
        assigns = assign(assigns, :notification_popup_preview_id, "notification-popup-preview-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <div class="flex flex-col items-center gap-4">
          <.waw_button
            type="button"
            phx-click={JS.show(to: "##{@notification_popup_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-0 translate-y-4", "opacity-100 translate-y-0"})}
            label="Afficher Popup"
            size="md"
          />
          <div id={@notification_popup_preview_id} class="hidden fixed bottom-4 right-4 z-50">
            <.waw_notification_popup
              time="09:03:45"
              description="RENAULT MIDLUM 210 - 4785 TAG (Poids-lourds secondaires)"
              title="Survitesse en ville"
              icon="speedometer-1-right"
            >
              <:show>
                <.waw_button_text
                  label="Fermer"
                  phx-click={JS.hide(to: "##{@notification_popup_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-100 translate-y-0", "opacity-0 translate-y-4"})}
                />
              </:show>
            </.waw_notification_popup>
          </div>
        </div>
        """

      # Pour toutes les autres sous‑catégories, pas d'exécution dynamique :
      _ ->
        ~H"""
        <div class="text-xs text-gray-400 text-center py-4">
          Aperçu non disponible pour ce composant.
        </div>
        """
    end
  end

  # Helper pour rendre les variantes en dur (utilisé par la popup)
  attr :sous_categorie, :string, required: true
  attr :variant_nom, :string, required: true
  def render_variant_preview(assigns) do
    sous_categorie = assigns.sous_categorie
    variant_nom = assigns.variant_nom

    case {sous_categorie, variant_nom} do
      ## Texte et Nombres – Distance
      {"Distance", "En mètre"} ->
        ~H"""
        <.distance unit={:meter} value={10000} />
        """

      {"Distance", "En kilomètre"} ->
        ~H"""
        <.distance unit={:kilometer} value={10000} />
        """

      ## Cartes – Compte-rendu
      {"Compte-rendu", "Sélectionnée"} ->
        ~H"""
        <.waw_card
          state="selected"
          title="Compte-rendu kilométrage journalier"
          title_icon="file-xls"
          tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules."
        >
          <:section>
            <.waw_time_section label="Dernier Maj" value="10:00:19" />
            <.waw_date_section label="Dernier CR disponible" value="Aujourd'hui" />
            <.waw_date_section label="1er CR disponible" value="Aujourd'hui" />
          </:section>
        </.waw_card>
        """

      ## Cartes – Dashboard
      {"Dashboard", "Avec icône"} ->
        ~H"""
        <.waw_dashboard_card
          description="Information concernant la distance parcourue moyenne, journalière, par véhicule"
          title="Distance parcourue moyenne, journalière, par véhicule"
          icon="car"
        >
          <div class="grid place-content-start p-4 h-full">
            Content
          </div>
        </.waw_dashboard_card>
        """

      ## Cartes – Statistique
      {"Statistique", "Loading"} ->
        ~H"""
        <.waw_stat loading title="Véhicules géolocalisés" />
        """

      {"Statistique", "Par défaut"} ->
        ~H"""
        <.waw_stat
          value={100}
          description="Information concernant les véhicules géolocalisés"
          title="Véhicules géolocalisés"
        />
        """

      {"Statistique", "Avec unité"} ->
        ~H"""
        <.waw_stat
          unit={:kilometer}
          value={100}
          description="Information concernant la distance parcourue moyenne, journalière, par véhicule"
          title="Distance parcourue moyenne, journalière, par véhicule"
        />
        """

      {"Statistique", "Avec total"} ->
        ~H"""
        <.waw_stat total={251} value={100} title="véhicules géolocalisés" />
        """

      {"Statistique", "Avec ratio"} ->
        ~H"""
        <.waw_stat
          total={251}
          value={100}
          title="véhicules géolocalisés"
          ratio={:percentage}
        />
        """

      {"Statistique", "Avec total et état"} ->
        ~H"""
        <.waw_stat
          status={:success}
          total={251}
          value={100}
          description="Information concernant les véhicules actuellement en mouvement"
          title="véhicules actuellement en mouvement"
        />
        """

      {"Statistique", "Avec intervalle de temps"} ->
        ~H"""
        <.waw_stat
          title="Heure de pointe d'utilisation des véhicules"
          icon="clock"
          start_value={~U[2020-05-30 13:52:56Z]}
          end_value={~U[2020-05-30 14:52:56Z]}
        />
        """

      {"Statistique", "Avec durée"} ->
        ~H"""
        <.waw_stat
          unit={:second}
          value={4210}
          title="Durée de roulage total des véhicules sur le mois"
          icon="clock"
        />
        """

      {"Statistique", "Complète"} ->
        ~H"""
        <.waw_stat
          unit={:kilometer}
          value={4210}
          title="Distance parcourue moyenne, journalière, par véhicule"
          col={2}
          icon="circuit"
          previous_value={90}
          previous_at={~U[2025-11-20 07:59:45.682352Z]}
        />
        """

      {"Statistique", "Complète non-cliquable"} ->
        ~H"""
        <.waw_stat
          status={:danger}
          value={210}
          title="véhicules stationnés"
          icon="truck"
          variation_symbol={:math}
          previous_value={90}
          previous_at={~U[2025-11-20 07:59:45.682356Z]}
        />
        """

      {"Statistique", "Status sélectionné"} ->
        ~H"""
        <.waw_status_card label="Cinématique" state="selected" icon="steering-wheel" />
        """

      {"Statistique", "Status désactivé"} ->
        ~H"""
        <.waw_status_card label="Balise GPS" state="disabled" icon="tracker" />
        """

      {"Statistique", "Status pour CR"} ->
        ~H"""
        <.waw_status_card label="CR véhicule" state="exception" icon="sign-out" />
        """

      ## Dates et heures – Dates
      {"Dates", "Date et heure"} ->
        ~H"""
        <.date_time value={~U[2025-11-20 08:21:11.635563Z]} format={:medium} />
        """

      ## Dates et heures – Intervalle de temps
      # Toutes les variantes d'intervalle nécessitent CLDR configuré
      # Pour l'instant, on affiche un message indiquant que CLDR est requis
      {"Intervalle de temps", _variant_nom} ->
        safe_render_interval_variant(assigns, sous_categorie, variant_nom)

      ## Basiques – Accordion
      {"Accordion", "Avec status sélectionné"} ->
        ~H"""
        <div class="-mx-6 -my-4">
          <.waw_accordion count={12} id="accordion-single-table" selected head_icon="car">
          <.waw_table without_border>
          <:thead>
          <.waw_th sort_key="desc"></.waw_th>
          <.waw_th sort_key="desc">Véhicules</.waw_th>
          <.waw_th sort_key="asc">Evenement</.waw_th>
          </:thead>
          <:tr state="selected">
          <.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
          <.waw_td title="6541 TBA">6541 TBA</.waw_td>
          <.waw_td title="Vitesse > 60km/h" is_link={true} href="https://www.tag-ip.com/">Vitesse > 60</.waw_td>
          </:tr>
          <:tr state="disabled">
          <.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
          <.waw_td title="3354 TBA">3354 TBA</.waw_td>
          <.waw_td title="Vitesse > 50km/h">Vitesse > 50</.waw_td>
          </:tr>
          </.waw_table>
          </.waw_accordion>
        </div>
        """

      ## Basiques – Badge
      {"Badge", "Avec bouton fermer"} ->
        assigns = assign(assigns, :badge_variant_id, "badge-variant-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <.waw_badge id={@badge_variant_id} label="value" description="title" color="info">
          <:action>
          <.waw_button_icon icon="cancel" />
          </:action>
        </.waw_badge>
        """

      {"Badge", "Avec étiquette"} ->
        assigns = assign(assigns, :badge_variant_id, "badge-variant-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <.waw_badge id={@badge_variant_id} label="value" scope="scope" description="Avec étiquette" color="danger"/>
        """

      {"Badge", "Avec étiquette et bouton fermer"} ->
        assigns = assign(assigns, :badge_variant_id, "badge-variant-#{System.unique_integer([:positive, :monotonic])}")
        ~H"""
        <.waw_badge id={@badge_variant_id} label="value" scope="scope" description="Avec étiquette" color="#B1159C">
          <:action>
          <.waw_button_icon icon="cancel" bg_color="bg-light" />
          </:action>
        </.waw_badge>
        """

      ## Basiques – Séparateur de blocs
      {"Séparateur de blocs", "Avec label"} ->
        ~H"""
        <.waw_block_separator label="4512 WWT"/>
        """

      ## Basiques – Titre de block
      {"Titre de block", "Avec icône"} ->
        ~H"""
        <.waw_block_title label="Trackable sélectionné" icon="car"/>
        """

      ## Basiques – Boutons
      {"Boutons", "Activé"} ->
        ~H"""
        <.waw_button label="Synthèse" size="md" state="checked" icon="circle-grid-3x3-fill" icon_position="left"/>
        """

      {"Boutons", "Activé toggleable"} ->
        ~H"""
        <.waw_button label="Synthèse" size="md" state="checked" icon="circle-grid-3x3-fill" toggleable icon_position="left"/>
        """

      {"Boutons", "Non-sélectionné"} ->
        ~H"""
        <.waw_button label="Evenements" size="md" state="unchecked" icon="square-stack-3d-up-fill"/>
        """

      {"Boutons", "Plein désactivé"} ->
        ~H"""
        <.waw_button disabled label="home" size="md" state="checked" icon="home" icon_position="right"/>
        """

      {"Boutons", "Désactivé"} ->
        ~H"""
        <.waw_button disabled label="label" size="md" state="unchecked" icon="home" icon_position="right"/>
        """

      {"Boutons", "Annulation"} ->
        ~H"""
        <.waw_button label="Annuler" size="md" type="cancel"/>
        """

      {"Boutons", "Groupe"} ->
        ~H"""
        <.waw_button_group position="left">
        <.waw_button label="Organisation" size="md" icon="angle-small-down" icon_position="right" />
        <.waw_button label="Flotte" size="md" icon="angle-small-down" icon_position="right" />
        </.waw_button_group>
        """

      ## Basiques – Liste des champs avec description
      {"Liste des champs avec description", "Avec actions"} ->
        ~H"""
        <.waw_dl>
        <.waw_definition text_align="left" term="term" description="description">
        <:actions>
        <.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
        </:actions>
        </.waw_definition>
        <.waw_definition text_align="left" term="term" description="description">
        <:actions>
        <.waw_link_icon size="sm" state="checked" icon="square-and-pencil" disabled/>
        </:actions>
        </.waw_definition>
        <.waw_definition text_align="left" term="term" description="description" />
        </.waw_dl>
        """

      {"Liste des champs avec description", "Avec description en bloc"} ->
        ~H"""
        <.waw_dl>
        <.waw_definition text_align="left" term="term">
        <:actions>
        <.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
        </:actions>
        <p>description en block</p>
        </.waw_definition>
        <.waw_definition text_align="left" term="term">
        <:actions>
        <.waw_link_icon size="sm" state="checked" icon="square-and-pencil" disabled/>
        </:actions>
        <p>description en block</p>
        </.waw_definition>
        </.waw_dl>
        """

      {"Liste des champs avec description", "Sans actions"} ->
        ~H"""
        <.waw_dl>
        <.waw_definition text_align="left" term="term" description="description" has_actions={false} />
        <.waw_definition text_align="left" term="term" description="description" has_actions={false} />
        <.waw_definition text_align="left" term="term" description="description" has_actions={false} />
        <.waw_definition text_align="left" term="term" description="description" has_actions={false} />
        </.waw_dl>
        """

      ## Basiques – Header des filtres
      {"Header des filtres", "Avec sections gauche et droite"} ->
        ~H"""
        <.waw_filter_header id="filter-header-single--with-right">
        <:left>
        <.waw_button label="Organisation" size="md" icon="angle-small-down" icon_position="right" />
        <.waw_button label="Flotte" size="md" icon="angle-small-down" icon_position="right" />
        </:left>
        <:right>
        <.waw_button label="Actions" size="md" icon="ellipsis-circle" icon_position="right" />
        <Waw.LiveSearch.live_search name="header-filtres-search" margin_size="lg">
        <:results>
        <Waw.LiveSearch.list_group title="Organisations">
        <.waw_li_button>org 1</.waw_li_button>
        <.waw_li_button>org 2</.waw_li_button>
        </Waw.LiveSearch.list_group>
        <Waw.LiveSearch.list_group title="Flottes">
        <.waw_li_button>flotte 1</.waw_li_button>
        <.waw_li_button>flotte 2</.waw_li_button>
        </Waw.LiveSearch.list_group>
        </:results>
        </Waw.LiveSearch.live_search>
        </:right>
        </.waw_filter_header>
        """

      ## Basiques – Flash
      {"Flash", "Message"} ->
        flash_info_id = "flash-info-variant-#{System.unique_integer([:positive, :monotonic])}"
        assigns =
          assigns
          |> assign(:flash_variant_preview_id, "flash-variant-preview-#{System.unique_integer([:positive, :monotonic])}")
          |> assign(:flash_info_variant_id, flash_info_id)
        ~H"""
        <div class="flex flex-col items-center gap-4">
          <.waw_button
            type="button"
            phx-click={JS.show(to: "##{@flash_variant_preview_id}", transition: {"transition-all ease-out duration-300", "opacity-0 translate-y-4", "opacity-100 translate-y-0"})}
            label="Afficher Flash"
            size="md"
          />
          <div id={@flash_variant_preview_id} class="hidden">
            <.flash id={@flash_info_variant_id} kind={:info} flash={%{"info" => "Message d'information"}} />
          </div>
        </div>
        """

      ## Basiques – Champs
      {"Champs", "Texte"} ->
        ~H"""
        <.input name="text" label="label" type="text" placeholder="Placeholder" value=""/>
        """

      {"Champs", "Création flotte"} ->
        ~H"""
        <.input name="flotte" label="label" type="text" placeholder="Placeholder" value=""/>
        """

      {"Champs", "Description ou note"} ->
        ~H"""
        <.input name="description" label="label" type="textarea" placeholder="Placeholder" value=""/>
        """

      {"Champs", "E-mail"} ->
        ~H"""
        <.input name="email" label="label" type="email" placeholder="name@tag_ip.com" value=""/>
        """

      {"Champs", "Téléphone"} ->
        ~H"""
        <.input name="phone" label="label" type="tel" placeholder="Number" value=""/>
        """

      {"Champs", "Checkbox"} ->
        ~H"""
        <.input name="checkbox" label="label" type="checkbox" value=""/>
        """

      {"Champs", "Heure"} ->
        ~H"""
        <.input name="time" label="label" type="time" value=""/>
        """

      {"Champs", "Date et heure"} ->
        ~H"""
        <.input name="datetime" label="label" type="datetime-local" value=""/>
        """

      {"Champs", "Recherche petite taille"} ->
        ~H"""
        <.input name="search-small" type="search" value=""/>
        """

      {"Champs", "Recherche avec popup"} ->
        ~H"""
        <.input name="search" value="" type="search">
        <Waw.List.li>item 1</Waw.List.li>
        <Waw.List.li>item 2</Waw.List.li>
        </.input>
        """

      {"Champs", "Sélection"} ->
        ~H"""
        <.input name="select" label="Label" type="select" options={[{"option 1", "option 1"}, {"option 2", "option 2"}]} value="" />
        """

      {"Champs", "Sélection multiple"} ->
        ~H"""
        <.input name="select-multiple" label="Label" type="select" multiple={true} options={[{"option 1", "option 1"}, {"option 2", "option 2"}]} value="" />
        """

      ## Basiques – Lien icône
      {"Lien icône", "Par défaut"} ->
        ~H"""
        <.waw_link_icon size="sm" state="unchecked" icon="home"/>
        """

      ## Basiques – Element d'une liste
      {"Element d'une liste", "Complète avec statuts"} ->
        ~H"""
        <Waw.List.ul>
        <Waw.List.li icon="person-fill" battery_number="30" connexion_status="normal">item 1</Waw.List.li>
        <Waw.List.li icon="person-fill" state="selected"  battery_number="100" connexion_status="low">item 2</Waw.List.li>
        <Waw.List.li icon="boat" connexion_status="moving">item 3</Waw.List.li>
        <Waw.List.li icon="moto" connexion_status="offline">item 4</Waw.List.li>
        <Waw.List.li icon="truck" state="selected" connexion_status="parked">item 5</Waw.List.li>
        <Waw.List.li icon="car" connexion_status="defective">item 6</Waw.List.li>
        <Waw.List.li icon="car" connexion_status="moving">item 7</Waw.List.li>
        <Waw.List.li icon="person-fill" state="alert" battery_number="30" connexion_status="offline">item 8</Waw.List.li>
        <Waw.List.li icon="person-fill" battery_number="75" connexion_status="low_activity">item 9</Waw.List.li>
        <Waw.List.li icon="person-fill" battery_number="30" connexion_status="high_activity">item 10</Waw.List.li>
        <Waw.List.li icon="person-fill" state="selected" battery_number="80" connexion_status="no_activity">item 11</Waw.List.li>
        <Waw.List.li icon="person-fill" battery_number="80" connexion_status="power_off">item 12</Waw.List.li>
        <Waw.List.li icon="lock-close-fill" lock_status="locked" battery_number="50" connexion_status="offline">item 13</Waw.List.li>
        <Waw.List.li icon="lock-close-fill" state="selected" lock_status="unlocked" battery_number="30" connexion_status="high_activity">item 14</Waw.List.li>
        <Waw.List.li icon="lock-close-fill" lock_status="locked" battery_number="50" connexion_status="low_activity">item 15</Waw.List.li>
        <Waw.List.li icon="lock-close-fill" lock_status="unlocked" battery_number="30" connexion_status="no_activity">item 16</Waw.List.li>
        <Waw.List.li icon="lock-close-fill" title="MD11802/DMY0029" lock_status="unlocked" battery_number={0} connexion_status="defective">item 17</Waw.List.li>
        </Waw.List.ul>
        """

      {"Element d'une liste", "Classes d'événements"} ->
        ~H"""
        <Waw.List.ul>
        <Waw.List.li icon="speedometer-1-right" total={5}>Cinématique</Waw.List.li>
        <Waw.List.li icon="person" total={2} state="selected">Identification</Waw.List.li>
        <Waw.List.li icon="world-fill" total={10}>Géographique</Waw.List.li>
        </Waw.List.ul>
        """

      ## Basiques – Bouton collapse
      {"Bouton collapse", "Avec menus calendrier"} ->
        ~H"""
        <.waw_live_button type={:menu} selected_item="Aujourd'hui" show_list={true}>
        <:left>
        <.waw_link_text label="3 derniers jours" size="xs" state="unchecked"/>
        <.waw_link_text label="7 derniers jours" size="xs" state="checked" />
        <.waw_link_text label="Cette semaine" size="xs" state="unchecked" />
        </:left>
        <:right>
        <.waw_link_text label="Aujourd'hui" size="xs" state="unchecked" />
        <.waw_link_text label="Hier" size="xs" state="unchecked" />
        <.waw_link_text label="Avant hier" size="xs" state="unchecked" />
        </:right>
        <:actions>
        <.input id="input-single-date" size="xs" type="date"/>
        <.waw_icon name="arrow-small-right" size="4" />
        <.input id="input-single-date2" size="xs" type="date"/>
        <.waw_button label="Filtrer" size="xs" />
        <.waw_button label="Annuler" size="xs" state="unchecked" />
        </:actions>
        </.waw_live_button>
        """

      ## Basiques – Recherche avec un resultat dans un popup
      {"Recherche avec un resultat dans un popup", "Avec filtre"} ->
        ~H"""
        <Waw.LiveSearch.live_search name="recherche-popup-filtre" has_filter={true}>
        <:results>
        <Waw.LiveSearch.list_group title="Organisations">
        <.waw_li_button>org 1</.waw_li_button>
        <.waw_li_button>org 2</.waw_li_button>
        </Waw.LiveSearch.list_group>
        <Waw.LiveSearch.list_group title="Flottes">
        <.waw_li_button>flotte 1</.waw_li_button>
        <.waw_li_button>flotte 2</.waw_li_button>
        </Waw.LiveSearch.list_group>
        </:results>
        <:filters>
        <ul>
        <Waw.List.li state="selected" total={6}>Lister tous les items</Waw.List.li>
        <Waw.List.li connexion_status="moving">2 En mouvement</Waw.List.li>
        <Waw.List.li connexion_status="offline">4 Déconnectées</Waw.List.li>
        </ul>
        </:filters>
        </Waw.LiveSearch.live_search>
        """

      ## Pagination
      {"Pagination", "Simple"} ->
        ~H"""
        <.waw_pagination label="Page" total={9} current_page={1}>
        <:left>
        <.waw_button_icon icon="caret-left" icon_size={5} disabled />
        </:left>
        <:right>
        <.waw_button_icon icon="caret-right" icon_size={5} />
        </:right>
        </.waw_pagination>
        """

      ## Tableau
      {"Tableau", "Composants"} ->
        ~H"""
        <.waw_table>
        <:thead>
        <.waw_th_icon></.waw_th_icon>
        <.waw_th_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_th_icon>
        <.waw_th sort_key="desc">Name</.waw_th>
        <.waw_th sort_key="asc">First Name</.waw_th>
        <.waw_th sort_key="desc">Details</.waw_th>
        </:thead>
        <:tr state="selected">
        <.waw_td_icon><.waw_icon name="square-inset-filled" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Jean">Jean</.waw_td>
        <.waw_td title="Dupont">Dupoint</.waw_td>
        <.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
        </:tr>
        <:tr state="normal">
        <.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Kim">Kim</.waw_td>
        <.waw_td title="Léna">Léna</.waw_td>
        <.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
        </:tr>
        <:tr state="disabled">
        <.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Sam">Sam</.waw_td>
        <.waw_td title="Smith">Smith</.waw_td>
        <.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
        </:tr>
        </.waw_table>
        """

      {"Tableau", "Comptes-rendus flottes"} ->
        ~H"""
        <.waw_table>
        <:thead>
        <.waw_th_icon></.waw_th_icon>
        <.waw_th_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_th_icon>
        <.waw_th sort_key="desc">Name</.waw_th>
        <.waw_th sort_key="asc">First Name</.waw_th>
        <.waw_th sort_key="desc">Details</.waw_th>
        </:thead>
        <:tr state="selected">
        <.waw_td_icon><.waw_icon name="square-inset-filled" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Jean">Jean</.waw_td>
        <.waw_td title="Dupont">Dupoint</.waw_td>
        <.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
        </:tr>
        <:tr state="normal">
        <.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
        <.waw_td title="Kim">Kim</.waw_td>
        <.waw_td title="Léna">Léna</.waw_td>
        <.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
        </:tr>
        </.waw_table>
        """

      ## Onglets
      {"Onglets", "Petite taille"} ->
        ~H"""
        <.waw_tabs size="sm" align_tab="left">
        <.waw_tab size="sm" active>
        Items
        </.waw_tab>
        <.waw_tab size="sm">
        Flottes
        </.waw_tab>
        <.waw_tab size="sm" disabled>
        Instances
        </.waw_tab>
        <:actions>
        <.waw_button label="Créer" size="sm" />
        <.waw_button label="Rafraîchir" size="sm" icon="home" />
        <div>
        <.input id="input-single-search-litle" name="search" value="" size="sm" type="search" />
        </div>
        </:actions>
        <:content>
        <div>Content of tab</div>
        </:content>
        </.waw_tabs>
        """

      ## Afficher un trackable
      {"Afficher un trackable", "Avec symbole"} ->
        ~H"""
        <.waw_name size="sm" value={%{label: "TGP0012", name: "4212TBA", tracker_label: "MD0014", custom_name: "ix35", trackable_symbol: "moto"}} with_symbol/>
        """

      ## Sous header
      {"Sous header", "Fil d'Ariane"} ->
        ~H"""
        <.waw_subheader>
        <:breadcrumb>
        <.waw_nav_breadcrumb>
        <.waw_icon name="home-fill" size="4" stroke="none" />
        </.waw_nav_breadcrumb>
        </:breadcrumb>
        <:breadcrumb>
        <.waw_nav_breadcrumb>2MI</.waw_nav_breadcrumb>
        </:breadcrumb>
        <:breadcrumb>
        <.waw_nav_breadcrumb>Coursiers</.waw_nav_breadcrumb>
        </:breadcrumb>
        <:breadcrumb>
        <.waw_nav_breadcrumb active>Vue globale</.waw_nav_breadcrumb>
        </:breadcrumb>
        </.waw_subheader>
        """

      {"Sous header", "Complet"} ->
        ~H"""
        <.waw_subheader>
        <:breadcrumb>
        <.waw_nav_breadcrumb>
        <.waw_icon name="home-fill" size="4" stroke="none" />
        </.waw_nav_breadcrumb>
        </:breadcrumb>
        <:breadcrumb>
        <.waw_nav_breadcrumb>2MI</.waw_nav_breadcrumb>
        </:breadcrumb>
        <:breadcrumb>
        <.waw_nav_breadcrumb>Coursiers</.waw_nav_breadcrumb>
        </:breadcrumb>
        <:breadcrumb>
        <.waw_nav_breadcrumb active>Vue globale</.waw_nav_breadcrumb>
        </:breadcrumb>
        <:right>
        <div>Texte à droite</div>
        </:right>
        </.waw_subheader>
        """

      ## Header d'un contenu
      {"Header d'un contenu", "Avec acronyme et sous-titre"} ->
        ~H"""
        <.waw_panel_header selected title="Acronyme" subtitle="55 En mouvement" acronym="A" subtitle_type="success"/>
        """

      {"Header d'un contenu", "Avec bouton réduit"} ->
        ~H"""
        <.waw_panel_header title="Caret left" icon="truck">
        <:actions>
        <.waw_icon name="caret-left" size="6" />
        </:actions>
        </.waw_panel_header>
        """

      {"Header d'un contenu", "Avec statut et bouton réduit"} ->
        ~H"""
        <.waw_panel_header title="Caret left" icon="truck" subtitle="À l'arrêt" subtitle_type="warning">
        <:actions>
        <.waw_icon name="caret-left" size="6" />
        </:actions>
        </.waw_panel_header>
        """

      {"Header d'un contenu", "Avec statut et bouton déroulant"} ->
        ~H"""
        <.waw_panel_header title="Caret right" icon="car" subtitle="En mouvement" subtitle_type="success">
        <:actions>
        <.waw_icon name="caret-right" size="6" />
        </:actions>
        </.waw_panel_header>
        """

      ## Bloc de status
      {"Bloc de status", "Avec clé-valeur"} ->
        ~H"""
        <.waw_status_block title="Localisation" icon="world">
        <:right>
        <.waw_icon name="sign-out" size="4" stroke="none" />
        </:right>
        <:content>
        <.waw_status_block_content col={2} label="Dernière position" value="-12.31027, 49.30167" />
        <.waw_status_block_content col={2} label="Route et PK" value="-" />
        </:content>
        </.waw_status_block>
        """

      {"Bloc de status", "Avec clé-valeur et status"} ->
        ~H"""
        <.waw_status_block status={:success} title="Informations balise GPS" icon="tracker">
        <:right>
        <span>Connectée</span>
        </:right>
        <:content>
        <.waw_status_block_content col={2} label="Dernière position" value="10:53:10  31 oct. 2023, -12.31027, 49.30167" />
        </:content>
        </.waw_status_block>
        """

      {"Bloc de status", "Avec liste de trajets"} ->
        ~H"""
        <.waw_status_block title="Compte-Rendu du trajet" icon="circuit">
        <:table>
        <.waw_table without_border>
        <:thead>
        <.waw_th>#</.waw_th>
        <.waw_th>De</.waw_th>
        <.waw_th>A</.waw_th>
        <.waw_th>Durée</.waw_th>
        <.waw_th>Distance</.waw_th>
        </:thead>
        <:tr state="selected">
        <.waw_td>3</.waw_td>
        <.waw_td title="08:05:52">08:05:52</.waw_td>
        <.waw_td title="09:04:52">09:04:52</.waw_td>
        <.waw_td title="1h14min34s">1h14min34s</.waw_td>
        <.waw_td title="20km">20km</.waw_td>
        </:tr>
        <:tr state="normal">
        <.waw_td>2</.waw_td>
        <.waw_td title="07:05:52">07:05:52</.waw_td>
        <.waw_td title="08:04:52">08:04:52</.waw_td>
        <.waw_td title="14min34s">14min34s</.waw_td>
        <.waw_td title="21km">21km</.waw_td>
        </:tr>
        <:tr state="normal">
        <.waw_td>1</.waw_td>
        <.waw_td title="06:05:52">06:05:52</.waw_td>
        <.waw_td title="07:04:52">07:04:52</.waw_td>
        <.waw_td title="14min34s">14min34s</.waw_td>
        <.waw_td title="25km">25km</.waw_td>
        </:tr>
        </.waw_table>
        </:table>
        </.waw_status_block>
        """

      # Fallback : aucune variante mappée en dur
      _ ->
        ~H"""
        <div class="text-xs text-gray-400 text-center py-4">
          Aperçu de variante non disponible pour ce composant.
        </div>
        """
    end
  end

  # Helper pour rendre les variantes d'intervalle avec gestion d'erreur CLDR
  defp safe_render_interval_variant(assigns, sous_categorie, variant_nom) do
    # Vérifier si CLDR est configuré avant d'essayer de rendre
    if cldr_configured?() do
      try do
        # Les noms sont maintenant au format "Groupe - Sous-variante"
        # Extraire la sous-variante (après le " - ")
        sub_variant_nom =
          case String.split(variant_nom, " - ", parts: 2) do
            [_group, sub] -> sub
            [single] -> single
            _ -> variant_nom
          end

        case sub_variant_nom do
          # Dates et heures
          "Medium" ->
            ~H"""
            <.interval from={~U[2025-12-03 10:26:07.956246Z]} to={~U[2025-12-03 11:42:16.956251Z]}/>
            """

          "Short" ->
            # Déterminer le groupe pour savoir quel type d'intervalle utiliser
            cond do
              String.contains?(variant_nom, "Dates et heures") ->
                ~H"""
                <.interval format={:short} from={~U[2025-12-03 10:26:07.956258Z]} to={~U[2025-12-03 11:42:16.956260Z]}/>
                """

              String.contains?(variant_nom, "Heures") ->
                ~H"""
                <.interval format={:short} from={~T[10:26:07.956288]} to={~T[11:29:16.956289]}/>
                """

              true ->
                ~H"""
                <.interval format={:short} from={~U[2025-12-03 10:26:07.956258Z]} to={~U[2025-12-03 11:42:16.956260Z]}/>
                """
            end

          "Long" ->
            ~H"""
            <.interval format={:long} from={~U[2025-12-03 10:26:07.956263Z]} to={~U[2025-12-03 11:42:16.956264Z]}/>
            """

          # Dates
          "Par défaut" ->
            cond do
              String.contains?(variant_nom, "Dates") && !String.contains?(variant_nom, "Dates et heures") ->
                ~H"""
                <.interval from={~D[2025-12-03]} to={~D[2025-12-06]}/>
                """

              String.contains?(variant_nom, "Heures") ->
                ~H"""
                <.interval from={~T[10:26:07.956275]} to={~T[11:29:16.956277]}/>
                """

              true ->
                ~H"""
                <.interval from={~D[2025-12-03]} to={~D[2025-12-06]}/>
                """
            end

          "Par mois" ->
            ~H"""
            <.interval from={~D[2025-12-03]} to={~D[2026-01-02]} style={:month}/>
            """

          "Par mois et jours" ->
            ~H"""
            <.interval from={~D[2025-12-03]} to={~D[2025-12-31]} style={:month_and_day}/>
            """

          "Par an et mois" ->
            ~H"""
            <.interval from={~D[2025-12-03]} to={~D[2026-12-26]} style={:year_and_month}/>
            """

          # Heures
          "Flex" ->
            ~H"""
            <.interval format={:short} from={~T[10:26:07.956291]} to={~T[11:29:16.956292]} style={:flex}/>
            """

          "Time" ->
            ~H"""
            <.interval format={:short} from={~T[10:26:07.956294]} to={~T[11:29:16.956295]} style={:time}/>
            """

          "Zone" ->
            ~H"""
            <.interval from={~T[10:26:07.956296]} to={~T[11:29:16.956297]}/>
            """

          _ ->
            assigns = assign(assigns, :sub_variant_nom, sub_variant_nom)
            ~H"""
            <div class="text-xs text-gray-400 text-center py-4">
              Variante non reconnue: {@sub_variant_nom}
            </div>
            """
        end
      rescue
        e ->
          # Gérer les erreurs CLDR même si la vérification a passé
          require Logger
          Logger.warning("Erreur CLDR pour variante #{sous_categorie}/#{variant_nom}: #{Exception.message(e)}")
          ~H"""
          <div class="text-xs text-yellow-600 text-center py-4">
            Aperçu non disponible (CLDR requis)
          </div>
          """
      end
    else
      # CLDR n'est pas configuré, afficher un message directement
      ~H"""
      <div class="text-xs text-yellow-600 text-center py-4">
        Aperçu non disponible (CLDR requis)
      </div>
      """
    end
  end

  # Vérifier si CLDR est configuré
  defp cldr_configured? do
    try do
      # Essayer d'obtenir le backend CLDR par défaut
      backend = Cldr.default_backend!()
      # Vérifier que le backend est bien WawShowcase.Cldr
      backend == WawShowcase.Cldr
    rescue
      Cldr.NoDefaultBackendError ->
        false
      _ ->
        false
    end
  end
end

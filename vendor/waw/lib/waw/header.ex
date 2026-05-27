defmodule Waw.Header do
  use Phoenix.Component

  use Gettext, backend: Waw.Gettext

  alias Phoenix.LiveView.JS

  alias Waw.Logo

  import Waw.Logo
  import Waw.Icons

  @moduledoc """
  Ceci est l'en-tete classique de Tag-IP

  - à gauche nous avons le logo du produit
  - puis le titre de la page
  - à droite nous avons quelques entrees (liens)
  - puis nous avons la barre de recherche dans un slot
  - puis les boutons
  - puis en dernier l'icone de l'utilisateur qui ouvre un menu

  """

  # define the coompnent attributes:
  # logo a string with a default value and enum values
  # the url related to the logo
  # a title string
  # a subtitle string
  # tab entries
  # a tab entry can be a link or a menu
  # a menu is a list of links
  # a search bar
  # some buttons
  # and a user icon with a menu

  attr(:logo, :string, default: "tag-ip", values: Logo.list(), doc: "Le
    logo à afficher")

  attr(:logo_url, :string, default: "https://tag-ip.com", doc: "L'url
    de la page du logo")

  attr(:title, :string, doc: "Le titre de la page courante")

  attr(:subtitle, :string, doc: "Le sous-titre de la page courante")

  attr(:is_dark, :boolean, default: false)

  attr(:connected_user, :map, doc: "L'utilisateur `E.Gereg.User` connecté")
  attr(:current_user, :map, doc: "L'utilisateur `E.Gereg.User` courant")

  attr(:user_home_url, :string, doc: "L'URL de la page d'accueil de
    l'utilisateur courant")

  attr(:connected_user_profile_url, :string, doc: "L'URL de la page de profil de l'utilisateur
    connecté")

  attr(:current_user_profile_url, :string, doc: "L'URL de la page de profil de l'utilisateur
    courant")

  attr(:logout_url, :string, doc: "L'URL de la page de deconnexion de
    l'utilisateur courant")

  attr(:notification_action, :any, doc: "Action lors du click sur les
    notifications, afficher la cloche si cet attribut existe")
  attr(:has_notifications, :boolean, default: false, doc: "Afficher un marqueur
    rouge si cet attribut est vrai")

  attr(:header_id, :string, default: "header", doc: "L'id DOM de l'en-tête,
    optionnel, utilise surtout dans storybook")

  slot :nav,
    doc: """
    Lien pour la navigation.
    Utiliser la fonction `waw_navbar` pour créer un lien.
    """ do
    attr(:active, :boolean, doc: "Lien actif")
    attr(:disabled, :boolean, doc: "Lien désactivé")
    attr(:action, :any, doc: "Action lors du click sur le lien")
    attr(:navigate, :string, doc: "Lien de navigation")
    attr(:tooltip, :string, doc: "Tooltip sur le hover")
    attr(:href, :string, doc: "Lien de navigation")
  end

  slot(:menu_entry, doc: "Une entrée du menu")
  slot(:actions, doc: "Une action dans le header")

  @doc """
  Afficher l'en-tête de Tag-IP.
  """

  def waw_header(assigns) do
    # Nouvelle version de header
    # generate a header component with the given attributes and tailwind classes
    ~H"""
    <header class={container(@is_dark)}>
      <div class="flex-1 flex items-center pl-2.5 font-semibold">
        <.link class="-mt-2" navigate={@logo_url}>
          <.logo name={@logo} />
        </.link>
        <.title :if={assigns[:title]} class="-mt-1 ml-3 text-base">
          {@title}
          <span :if={assigns[:subtitle]}>
            |&nbsp;{@subtitle}
          </span>
        </.title>
      </div>
      <nav :if={assigns[:nav]} class="hidden lg:flex flex-none px-2 mx-2 -mr-1">
        <.link :for={nav <- @nav} {nav_attributes(nav, @is_dark)}>
          {render_slot(nav)}
        </.link>
      </nav>
      <div class="flex items-center justify-center space-x-4 pr-2 lg:pr-4 pb-0.5">
        <.link
          :if={assigns[:notification_action]}
          phx-click={assigns[:notification_action]}
        >
          <div
            :if={@has_notifications}
            class="absolute  bg-danger border-0 w-2.5 h-2.5 rounded-full ml-3"
          />
          <.waw_icon name="bell-fill" size="4" />
        </.link>
        <.link
          :if={not is_nil(assigns[:user_home_url])}
          href={assigns[:user_home_url]}
        >
          <.waw_icon name="circle-grid-3x3" size="4" />
        </.link>
        <.link
          :if={assigns[:connected_user] && assigns[:current_user]}
          phx-click={show_hide_modal("#{@header_id}_user_menu")}
        >
          <.waw_icon name="person-fill" size="4" />
        </.link>
        <div
          class="flex lg:hidden items-center justify-center"
          phx-click={show_hide_modal("#{@header_id}_nav")}
        >
          <.waw_icon name="menu-burger" size="4" stroke="none" />
        </div>
      </div>
    </header>
    <div
      id={"#{@header_id}_nav"}
      class={"#{popup_class(@is_dark)} hidden absolute top-12 mt-0.5 right-0.5 z-50 p-1 rounded-md h-auto w-auto flex-col items-start lg:hidden"}
    >
      <.link :for={nav <- @nav} {nav_attributes(nav, @is_dark)}>
        {render_slot(nav)}
      </.link>
    </div>
    <.waw_user_menu
      :if={assigns[:connected_user] && assigns[:current_user]}
      header_id={@header_id}
      logout_url={assigns[:logout_url]}
      current_user_profile_url={assigns[:current_user_profile_url]}
      connected_user_profile_url={assigns[:connected_user_profile_url]}
      connected_user={assigns[:connected_user]}
      current_user={assigns[:current_user]}
    >
      <%= if assigns[:menu_entry] do %>
        <%= for menu_entry <- @menu_entry do %>
          {render_slot(menu_entry)}
        <% end %>
      <% end %>
    </.waw_user_menu>
    """
  end

  defp nav_attributes(nav, is_dark) do
    [
      class:
        ~w"px-2 lg:px-3 pt-1.5 lg:pt-3 font-sfpro-regular text-xs lg:text-sm h-8 lg:h-auto flex flex-col lg:flex-row"
    ]
    |> add_nav_attribute(:tooltip, Map.get(nav, :tooltip), is_dark)
    |> add_nav_attribute(:navigate, Map.get(nav, :navigate), is_dark)
    |> add_nav_attribute(:href, Map.get(nav, :href), is_dark)
    |> add_nav_attribute(:action, Map.get(nav, :action), is_dark)
    |> add_nav_attribute(:active, Map.get(nav, :active), is_dark)
    |> add_nav_attribute(:disabled, Map.get(nav, :disabled), is_dark)
  end

  defp add_nav_attribute(attr, _key, nil, _), do: attr

  defp add_nav_attribute(attr, :tooltip, tooltip, _) do
    attr
    |> Keyword.put(:title, tooltip)
  end

  defp add_nav_attribute(attr, :active, true, is_dark) do
    attr
    |> Keyword.update!(:class, fn class ->
      ~w"cursor-default #{active_tab_class(is_dark)}" ++
        class
    end)
    |> Keyword.drop([:navigate, :"phx-click", :href])
  end

  defp add_nav_attribute(attr, :disabled, true, _) do
    attr
    |> Keyword.update!(
      :class,
      fn class ->
        ~w"opacity-40 cursor-not-allowed " ++
          Enum.reject(class, fn
            "cursor-default" ->
              true

            "cursor-pointer" ->
              true

            _ ->
              false
          end)
      end
    )
    |> Keyword.drop([:navigate, :"phx-click", :href, :action])
  end

  defp add_nav_attribute(attr, :active, _, _), do: attr

  defp add_nav_attribute(attr, :navigate, href, _) do
    attr
    |> Keyword.put(:navigate, href)
    |> Keyword.update!(:class, fn class ->
      ~w"cursor-pointer " ++ class
    end)
  end

  defp add_nav_attribute(attr, :href, href, _) do
    attr
    |> Keyword.put(:href, href)
    |> Keyword.update!(:class, fn class ->
      ~w"cursor-pointer " ++ class
    end)
  end

  defp add_nav_attribute(attr, :action, action, _) do
    attr
    |> Keyword.put(:"phx-click", action)
    |> Keyword.update!(:class, fn class ->
      ~w"cursor-pointer " ++ class
    end)
  end

  defp add_nav_attribute(attr, _key, _value, _), do: attr

  attr(:logo, :string, default: "track", values: ["track", "tag-ip"])
  attr(:logo_url, :string, default: "https://tag-ip.com")

  attr(:title, :string, default: "")
  attr(:subtitle, :string, default: "")
  attr(:is_dark, :boolean, default: true)

  attr(:popup_is_visible, :boolean, default: false)

  attr(:user_email, :string, default: "")
  attr(:user_name, :string, default: "")
  attr(:log_out_url, :string, default: "")
  attr(:profile_url, :string, default: "")

  attr(:header_id, :string, default: "header", doc: "L'id DOM de l'en-tête,
    optionnel, utilise surtout dans storybook")

  slot(:nav,
    doc: """
    Lien pour la navigation.
    Utiliser la fonction `waw_navbar` pour créer un lien.
    """
  )

  slot(:actions, doc: "Boutons d'actions")

  attr(:rest, :global)

  @doc """
  Ancienne version du header
  """
  @deprecated "Use `#{__MODULE__}.waw_header/1` mais il y a des modifications"
  def header(assigns) do
    # generate a header component with the given attributes and tailwind classes
    ~H"""
    <header class={container(@is_dark)}>
      <div class="flex-1 flex items-center pl-2.5 font-semibold">
        <.link class="-mt-2" href={@logo_url}>
          <.logo name={@logo} />
        </.link>
        <.title class="-mt-1 ml-3 text-base">
          {@title}
          <span :if={@subtitle !== ""}>: {@subtitle}</span>
        </.title>
      </div>
      <nav class="hidden lg:flex flex-none px-2 mx-2 -mr-1">
        {render_slot(@nav)}
      </nav>
      <div class="flex items-center justify-center space-x-4 pr-2 lg:pr-4 pb-0.5">
        {render_slot(@actions)}
        <div
          class="flex lg:hidden items-center justify-center"
          phx-click={show_hide_modal("#{@header_id}_nav")}
        >
          <.waw_icon name="menu-burger" size="4" stroke="none" />
        </div>
      </div>
    </header>
    <div
      id={"#{@header_id}_nav"}
      class={"#{popup_class(@is_dark)} hidden absolute top-12 mt-0.5 right-0.5 z-50 p-1 rounded-md h-auto w-auto flex-col items-start lg:hidden"}
    >
      {render_slot(@nav)}
    </div>
    <div :if={@popup_is_visible} class="z-40 w-full flex justify-end">
      <div class="h-auto w-auto m-0.5 absolute bg-gray-100 z-40 shadow-left-bottom-right rounded-md text-xs lg:text-sm">
        <div class="flex items-center justify-center mt-2">
          <span class="text-info">{@user_name}</span>
        </div>
        <div class="flex items-center justify-center m-1">
          <.waw_icon name="person-crop-circle" size="5" stroke="none" />
        </div>
        <div class="flex items-center justify-center px-3 my-1">
          <span class="text-gray-700">{@user_email}</span>
        </div>
        <div class="flex items-center justify-center px-3 mt-2 mb-2">
          <.link navigate={@profile_url}>
            <span class="text-gray-700 font-semibold">Préférences</span>
          </.link>
        </div>
        <div class="border-b border-neutral-70"></div>
        <div class="flex items-center justify-center p-2">
          <.link navigate={@log_out_url}>
            <div class="flex items-center border rounded-md p-1 justify-center font-medium text-xs">
              Déconnexion
            </div>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  attr(:header_id, :string)
  attr(:connected_user, :any)
  attr(:current_user, :any)
  attr(:connected_user_profile_url, :string)
  attr(:current_user_profile_url, :string)
  attr(:logout_url, :string)

  slot :menu_entry, doc: "slot menu", required: false do
    attr(:navigate, :string, doc: "Title")
    attr(:href, :string, doc: "URL")
  end

  def waw_user_menu(assigns) do
    ~H"""
    <div
      id={"#{@header_id}_user_menu"}
      class="z-40 w-full justify-end hidden relative"
    >
      <div class="h-auto w-auto m-0.5 absolute right-0 top-0 z-40 shadow-left-bottom-right text-xs lg:text-sm">
        <div class="h-auto w-44 lg:w-48 z-40 divide-y rounded-md border border-gray-400 shadow-lg divide-gray-400 border-default-primary bg-dark">
          <div>
            <div
              :if={@connected_user.id != @current_user.id}
              class="px-4 pt-2.5 pb-2 text-white"
            >
              <h1 class="block pb-1 text-xs font-medium uppercase text-gray-400">
                {gettext("Utilisateur connecté")}
              </h1>
              <div>{@connected_user.name}</div>
              <div class="font-medium truncate">{@connected_user.name}</div>
            </div>
            <div
              :if={@connected_user.id != @current_user.id}
              class="py-2 text-gray-200 border-t border-t-neutral-700"
            >
              <.link href={@connected_user_profile_url}>
                <div class="block rounded-sm mx-0.5 px-4 py-0.5 hover:bg-gray-600 hover:text-white">
                  {gettext("Préférences")}
                </div>
              </.link>
            </div>
          </div>

          <div>
            <div class="px-4 pt-2.5 pb-2 text-white">
              <h1 class="block pb-1 text-xs font-medium uppercase text-gray-400">
                {gettext("Utilisateur courant")}
              </h1>
              <div>{@current_user.name}</div>
              <div class="font-medium truncate">{@current_user.email}</div>
            </div>
            <div class="py-2 text-gray-200 border-t border-t-neutral-700">
              <.link href={@connected_user_profile_url}>
                <div class="block rounded-sm mx-0.5 px-4 py-0.5 hover:bg-gray-600 hover:text-white">
                  {gettext("Préférences")}
                </div>
              </.link>
            </div>
          </div>
          <div
            :if={not is_nil(assigns[:menu_entry]) and length(@menu_entry) > 0}
            class={menu_entry_class(assigns[:menu_entry])}
          >
            <.link
              :for={menu_entry <- @menu_entry}
              {menu_entry_attributes(menu_entry)}
            >
              {render_slot(menu_entry)}
            </.link>
          </div>
          <div class="py-2 text-gray-200">
            <.link href={@logout_url}>
              <div class="block rounded-sm mx-0.5 px-4 py-0.5 hover:bg-gray-600 hover:text-white">
                {gettext("Déconnexion")}
              </div>
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp menu_entry_attributes(nav) do
    [
      class: ~w"block rounded-sm mx-0.5 px-4 py-0.5 hover:bg-gray-600 hover:text-white"
    ]
    |> add_menu_entry_attribute(:navigate, Map.get(nav, :navigate))
  end

  defp add_menu_entry_attribute(attr, :navigate, href) do
    attr
    |> Keyword.put(:navigate, href)
    |> Keyword.update!(:class, fn class ->
      ~w"cursor-pointer " ++ class
    end)
  end

  defp add_menu_entry_attribute(attr, _key, _value), do: attr

  defp menu_entry_class(assigns) do
    if assigns do
      "py-2 text-gray-200"
    else
      "hidden"
    end
  end

  @deprecated "Use `#{__MODULE__}.waw_user_menu/1`"
  defdelegate user_menu(assigns), to: __MODULE__, as: :waw_user_menu

  def show_hide_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.toggle(to: "##{id}")
  end

  attr(:active, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  slot(:inner_block, required: true)
  attr(:rest, :global)
  attr(:theme, :string, default: "dark", values: ["dark", "light"])

  @doc "Barre de navigation"
  def waw_navbar(assigns) do
    ~H"""
    <div class="flex">
      <.link
        :if={Map.get(assigns, :active, false) and @active}
        class={selected_tab(@active, @theme)}
      >
        {render_slot(@inner_block)}
      </.link>
      <.link
        :if={!Map.get(assigns, :active, false) and !Map.get(assigns, :disabled, false)}
        class={selected_tab(false, @theme)}
        {@rest}
      >
        {render_slot(@inner_block)}
      </.link>
      <.link
        :if={!Map.get(assigns, :active, false) and Map.get(assigns, :disabled, false)}
        class={disabled_tab(@disabled)}
      >
        {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @deprecated "Use `#{__MODULE__}.waw_navbar/1`"
  defdelegate navbar(assigns), to: __MODULE__, as: :waw_navbar

  @doc "Afficher un titre"
  attr(:class, :string)
  slot(:inner_block, required: true)

  def waw_title(assigns) do
    # generate a title with the given attributes and tailwind classes
    ~H"""
    <h1 class={@class}>{render_slot(@inner_block)}</h1>
    """
  end

  @deprecated "Use `#{__MODULE__}.waw_title/1`"
  defdelegate title(assigns), to: __MODULE__, as: :waw_title

  defp container(false) do
    "w-full navbar flex shadow-lg text-dark bg-lite h-12 lg:h-14 pt-1.5"
  end

  defp container(_) do
    "w-full navbar flex shadow-lg text-white bg-dark h-12 lg:h-14 pt-1.5"
  end

  defp selected_tab(true, "light") do
    "lg:border-b-4 lg:border-dark text-info lg:text-dark cursor-default px-2 lg:px-3 pt-1.5 lg:pt-3 font-sfpro-regular text-xs lg:text-sm h-8 lg:h-auto"
  end

  defp selected_tab(true, _) do
    "lg:border-b-4 lg:border-white text-info lg:text-white cursor-default px-2 lg:px-3 pt-1.5 lg:pt-3 font-sfpro-regular text-xs lg:text-sm h-8 lg:h-auto"
  end

  defp selected_tab(_, "light") do
    "px-2 lg:px-3 pt-1.5 lg:pt-3 lg:pb-1 text-dark font-sfpro-regular text-xs lg:text-sm h-8 lg:h-auto"
  end

  defp selected_tab(_, _) do
    "px-2 lg:px-3 pt-1.5 lg:pt-3 lg:pb-1 text-white font-sfpro-regular text-xs lg:text-sm h-8 lg:h-auto"
  end

  defp disabled_tab(true) do
    "opacity-40 cursor-default px-2 lg:px-3 pt-1.5 lg:pt-3 lg:pb-1 font-sfpro-regular text-xs lg:text-sm h-8 lg:h-auto"
  end

  defp popup_class(false) do
    "bg-lite text-dark"
  end

  defp popup_class(_) do
    "bg-dark text-white"
  end

  defp active_tab_class(false) do
    "text-info lg:text-dark lg:border-b-4 lg:border-dark"
  end

  defp active_tab_class(_) do
    "text-info lg:text-white lg:border-b-4 lg:border-white"
  end
end

defmodule WawShowcaseWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use WawShowcaseWeb, :controller
      use WawShowcaseWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      use Gettext, backend: WawShowcaseWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # Translation
      use Gettext, backend: WawShowcaseWeb.Gettext

      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components
      import WawShowcaseWeb.CoreComponents

      # Waw Components imports
      import Waw.Icons, except: [icon: 1]
      import Waw.Flash, except: [flash: 1, flash_group: 1]
      import Waw.Header, except: [waw_navbar: 1]
      import Waw.Delegates
      import Waw.Tooltip
      import Waw.LiveFilter
      import Waw.Steps
      import Waw.Pagination
      import Waw.BlockTitle
      import Waw.BlockSeparator
      import Waw.ButtonGroup
      import Waw.FuelCard
      import Waw.Text.Number
      import Waw.Text.Text

      # Common modules used in templates
      alias Phoenix.LiveView.JS
      alias WawShowcaseWeb.Layouts
      alias Jason

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: WawShowcaseWeb.Endpoint,
        router: WawShowcaseWeb.Router,
        statics: WawShowcaseWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

defmodule WawShowcaseWeb.ErrorHTML do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on HTML requests.

  See config/config.exs.
  """
  use WawShowcaseWeb, :html

  # Utiliser des templates HEEx pour les pages d'erreur :
  #   * lib/waw_showcase_web/controllers/error_html/404.html.heex
  #   * lib/waw_showcase_web/controllers/error_html/500.html.heex
  embed_templates "error_html/*"

  # Fallback générique si aucun template dédié n'existe.
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

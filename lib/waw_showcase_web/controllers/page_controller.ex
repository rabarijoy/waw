defmodule WawShowcaseWeb.PageController do
  use WawShowcaseWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

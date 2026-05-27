defmodule Waw.Pages.PageError do
  @moduledoc """
    Afficher une page d'erreur
  """
  use Phoenix.Component

  attr(:rest, :global)

  attr(:title, :string,
    default: "Page introuvable",
    doc: "The error title"
  )

  attr(:text, :string,
    default: "...On a perdu votre page dans l'espace-temps",
    doc: "The error text"
  )

  attr(:url, :string,
    default: "",
    doc: "Url of the page"
  )

  slot(:background_image, doc: "Background-image")
  slot(:actions, required: true, doc: "link from button")

  @doc """
  Afficher une page d'erreur

  ## Usage

  ```
  <.waw_page_error url="https://tag-ip.com">
    <:background_image>
      <div class="background-image-astro">
      </div>
    </:background_image>
    <:actions>
      <.link>
        Revenez à la base
      </.link>
    </:actions>
  </.waw_page_error>
  ```
  """

  def waw_page_error(assigns) do
    ~H"""
    <div class="flex flex-col h-screen w-full bg-gradient-to-b from-blue-800 to-blue-900">
      <div class="mt-16 ml-16">
        <div class="text-xl text-light">
          TAG-IP
        </div>
        <div class="w-1/3 mt-6">
          <div class="text-3xl text-light">
            "{@text}"
          </div>
        </div>
      </div>
      <div class="mb-3 flex items-center justify-center">
        <div class="text-5xl text-light">
          {@title}
        </div>
      </div>
      <div :if={assigns[:url]} class="mb-16 flex items-center justify-center">
        <div class="text-xl text-light">
          <a href={@url}>
            {@url}
          </a>
        </div>
      </div>
      <div class="mb-24 flex items-center justify-center h-full w-full">
        <div>
          {render_slot(@background_image)}
        </div>
      </div>
      <div
        :if={assigns[:actions]}
        class="flex-none mb-16 w-full flex items-center justify-center"
      >
        <div
          class="border border-blue-600 bg-blue-600 hover:border-blue-800 hover:bg-blue-800 rounded-md py-3 px-6 text-4xl text-white"
          {@rest}
        >
          {render_slot(@actions)}
        </div>
      </div>
    </div>
    """
  end
end

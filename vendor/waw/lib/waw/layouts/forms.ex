defmodule Waw.Layouts.Forms do
  @moduledoc """
    Afficher un layout pour les formulaires
  """

  use Phoenix.Component

  import Waw.Styleguide.Typograghy

  attr(:rest, :global)

  slot(:header)
  slot(:grid_content)
  slot(:actions)

  @doc """
  Afficher le formulaire

  ## Usage

  ```heex
    <.waw_forms>
      <:header>
        ...
      </:header>
      <:grid_content>
        <.waw_grid>
          ...
        </.waw_grid>
      </:grid_content>
      <:actions>
        ...
      </:actions>
    </.waw_forms>
  ```
  """

  def forms(assigns) do
    ~H"""
    <div class="m-auto space-y-8 p-16 text-dark" {@rest}>
      <div class="text-center text-info-primary">
        <.h5>
          {render_slot(@header)}
        </.h5>
      </div>

      <div>
        {render_slot(@grid_content)}
        <div class="flex space-x-10 mt-10">
          {render_slot(@actions)}
        </div>
      </div>
    </div>
    """
  end

  attr(:grid_cols, :string,
    default: "cols-2",
    doc: "Spécifie le nombre de colonnes",
    values: ~w(cols-1 cols-2 cols-3 cols-4)
  )

  slot(:inner_block)

  @doc """
  Utilitaires pour spécifier les colonnes dans une disposition en grille.

  ## Usage

  ```heex
    <.waw_grid grid_cols="cols-3">
      ...
    </.waw_grid>
  ```
  """

  def grid(assigns) do
    ~H"""
    <div class={[grid_class(:grid_cols, assigns)]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp grid_class(:grid_cols, %{grid_cols: grid_cols}) do
    "mb-5 grid grid-cols-1 gap-x-5 gap-y-8 sm:grid-#{grid_cols}"
  end
end

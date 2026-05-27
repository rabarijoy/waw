defmodule Waw.Steps do
  @moduledoc """
  Afficher le steps.
  """
  use Phoenix.Component

  import Waw.Icons

  @doc """
  Afficher les étapes.

  ## Usage
  ```
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
  ```
  """

  slot :step, doc: "slot step is state and status" do
    attr(:active, :boolean)
    attr(:disabled, :boolean)

    attr(:status, :atom,
      values: [:valid, :invalid, :disabled],
      required: true
    )
  end

  attr(:rest, :global)

  def waw_steps(assigns) do
    ~H"""
    <ol class="flex items-center w-full text-sm font-semibold text-center text-gray-500 dark:text-gray-400">
      <li
        :for={{st, index} <- Enum.with_index(@step)}
        class={[
          "flex md:w-full items-center text-dark",
          if(index < length(@step) - 1,
            do:
              "sm:after:content-[''] after:w-full after:h-1 after:border-b after:border-gray-300 after:border-1 after:hidden sm:after:inline-block after:mx-6 xl:after:mx-10 dark:after:border-gray-700",
            else: ""
          )
        ]}
        {@rest}
      >
        <span :if={st.status == :valid} class="me-2.5 mb-0.5">
          <.waw_icon name="check-success" size="4" stroke="none" />
        </span>
        <span :if={st.status == :invalid} class="me-2.5 mt-1">
          <.waw_icon
            name="exclamationmark-triangle-invalid"
            size="5"
            stroke="none"
          />
        </span>

        <span :if={st.status == :disabled} class="me-2.5 mt-1">
          <.waw_icon
            name="exclamationmark-triangle-disabled"
            size="5"
            stroke="none"
          />
        </span>
        <div
          :if={Map.get(st, :active, false) and !Map.get(st, :disabled, false)}
          class="text-info hover:text-info-primary flex justify-start md:min-w-max pr-3"
        >
          {render_slot(st)}
        </div>
        <.link
          :if={!Map.get(st, :active, false) and !Map.get(st, :disabled, false)}
          class="text-dark cursor-pointer hover:text-info-primary flex justify-start md:min-w-max pr-3"
        >
          {render_slot(st)}
        </.link>
        <div
          :if={Map.get(st, :disabled, false)}
          class="text-default cursor-not-allowed flex justify-start md:min-w-max pr-3"
        >
          {render_slot(st)}
        </div>
      </li>
    </ol>
    """
  end
end

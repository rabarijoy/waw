defmodule Waw.CheckboxList do
  @moduledoc """
    Afficher une liste de checkbox.
  """

  use Phoenix.Component

  @doc """
  Afficher une liste de checkbox.

  ## Usage

  ```
    <.waw_checkbox_list
      title="Les tags suivants sont assignés : "
      subtitle="Veuillez selectionner les tags à enlever."
      id="assigned_tags"
      phx-update="ignore"
    >
      <:checkbox :for={tag <- @assigned_tags}>
        <.waw_input
          type="checkbox-choices"
          field={@form[:to_unassign]}
          value="value"
          label="label"
        />
      </:checkbox>
    </.waw_checkbox_list>
  ```
  """

  attr(:id, :string, required: true)
  attr(:rest, :global)
  attr(:title, :string)
  attr(:subtitle, :string)
  attr(:size, :string, default: "sm", values: ["xs", "sm", "md", "lg"])

  slot(:checkbox, required: true)

  def waw_checkbox_list(assigns) do
    ~H"""
    <div>
      <p :if={assigns[:title]} class={"flex flex-wrap text-" <> @size}>
        {@title}
      </p>
      <p
        :if={assigns[:subtitle]}
        class="text-pretty text-sm text-default-lite mb-2"
      >
        {@subtitle}
      </p>
      <div>
        <ul id={"#{@id}_selection"} {@rest}>
          <li :for={c <- @checkbox}>
            {render_slot(c)}
          </li>
        </ul>
      </div>
    </div>
    """
  end
end

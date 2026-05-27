defmodule Waw.Input do
  @moduledoc """
  Afficher les champs de saisie.
  """

  use Phoenix.Component

  require Logger

  import Waw.Icons

  attr(:id, :any, default: nil)
  attr(:name, :any)
  attr(:label, :any, default: nil)
  attr(:value, :any)
  attr(:step, :any)
  attr(:list, :any)
  attr(:max, :string)
  attr(:min, :string)

  attr(:type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)
  )

  attr(:field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"
  )

  attr(:errors, :list, default: [])
  attr(:checked, :boolean, doc: "the checked flag for checkbox inputs")

  attr(:invert_choice, :boolean,
    default: false,
    doc: "Pour le checkbox-choices permet d'inverser le choix"
  )

  attr(:prompt, :string, default: nil, doc: "the prompt for select inputs")

  attr(:options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2")

  attr(:multiple, :boolean,
    default: false,
    doc: "the multiple flag for select inputs"
  )

  attr(:password_is_visible, :boolean,
    default: false,
    doc: "check if passwordis visible"
  )

  attr(:tooltip_is_visible, :boolean, default: false)
  attr(:add_on, :boolean, default: false)
  attr(:visible, :boolean, default: true)

  attr(:add_on_text, :string, default: "")
  attr(:textarea_value, :string)

  attr(:placeholder, :string)
  # search attribute
  attr(:size, :string, default: "lg", values: ["xs", "sm", "md", "lg"])
  attr(:popup_is_visible, :boolean, default: false)

  # text attribute
  attr(:text_type, :string,
    default: "text",
    values: ["text", "email", "textarea", "password"]
  )

  attr(:icon, :string,
    doc: "Icon name",
    values: Waw.Icons.icon_list()
  )

  attr(:error, :string)

  attr(:rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)
  )

  slot(:inner_block)
  slot(:tooltip_block)

  @doc """
  Afficher differents types de champs de saisie.

  ## Usage

  - Exemple 1
  ```heex
    <.waw_input
      id="input-single-text"
      size="sm"
      type="text"
      placeholder="Placeholder"
    />
  ```

  - Exemple 2
  ```heex
    <.waw_input
      id="input-single-email"
      size="sm"
      type="text"
      placeholder="name@tag_ip.com"
      text_type="email"
      error="Provide a valid email address"
    />
  ```

  - Exemple 3
  ```heex
    <.waw_input
      id="input-single-text"
      size="sm"
      type="text"
      placeholder="Placeholder"
      label="label"
      tooltip_is_visible
    >
      <:tooltip_block>
        <.waw_tooltip position="top" color="white" content="Information du tooltip" variant="arrow" margin="top">
          (**)
        </.waw_tooltip>
      </:tooltip_block>
    </.waw_input>
  ```
  """

  def waw_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(
      :errors,
      if assigns.type == "datetime-local" do
        Waw.Helpers.translate_errors(
          assigns.field.form.source.errors,
          assigns.field.field
        )
      else
        Enum.map(field.errors, &Waw.Helpers.translate_error(&1))
      end
    )
    |> assign_new(:name, fn ->
      if assigns.multiple or assigns.type == "checkbox-choices",
        do: field.name <> "[]",
        else: field.name
    end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def waw_input(%{type: "checkbox-choices", field: nil} = assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:checked])
      end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <label
          :if={assigns[:label]}
          class="ml-0.5 mb-2 text-sm font-medium text-dark"
        >
          <input
            name={@name}
            value={@value}
            checked={@checked}
            type="checkbox"
            {@rest}
          />
          {@label}
        </label>
        <.error :for={msg <- @errors}>{msg}</.error>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "checkbox", field: nil} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <label
          :if={assigns[:label]}
          class="ml-0.5 mb-2 text-sm font-medium text-dark"
          for={@id}
        >
          <input type="hidden" value="false" name={@name} />
          <input
            id={@id}
            name={@name}
            value="true"
            checked={@checked}
            type="checkbox"
            {@rest}
          />
          {@label}
        </label>
        <.error :for={msg <- @errors}>{msg}</.error>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "checkbox"} = assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)
      |> assign_new(:checked, fn -> assigns[:checked] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <input
        id={@id}
        type="checkbox"
        name={@name}
        value={@value}
        checked={@checked}
        class="border rounded border-default"
        {@rest}
      />
      <label
        :if={assigns[:label]}
        class="ml-0.5 mb-2 text-sm font-medium text-dark"
        for={@id}
      >
        {@label}
      </label>
    </div>
    """
  end

  def waw_input(%{type: "textarea", field: nil} = assigns) do
    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <div>
          <.label :if={assigns[:label]} size={@size} for={@id}>
            {@label}
          </.label>
          <textarea
            id={@id}
            name={@name}
            class={[
              textarea_class(@size),
              @errors == [] && "border-zinc-300 focus:border-zinc-400",
              @errors != [] && "border-danger focus:border-danger"
            ]}
            {@rest}
          ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
          <.error :for={msg <- @errors}>{msg}</.error>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "select", field: nil} = assigns) do
    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <div>
          <.label :if={@label} for={@id} size={@size}>{@label}</.label>
          <select
            id={@id}
            name={@name}
            class={[input_class(@size), @errors, "border rounded border-default"]}
            multiple={@multiple}
            {@rest}
          >
            <option :if={@prompt} value="">{@prompt}</option>
            {Phoenix.HTML.Form.options_for_select(@options, @value)}
          </select>
          <.error :for={msg <- @errors}>{msg}</.error>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "select"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div>
        <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
          {@label}
        </label>
        <select
          id={@id}
          class={[
            input_class(@size),
            @error_class,
            "border rounded border-default"
          ]}
          name={@name}
          value={@value}
          {@rest}
        >
          {render_slot(@inner_block)}
        </select>
        <p
          :if={assigns[:error] && assigns[:error] != ""}
          class="absolute block text-danger text-xs mt-1"
        >
          <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
        </p>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "color", field: nil} = assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="relative">
        <div>
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <div class="relative">
            <input
              id={@id}
              type={@type}
              class="block w-full rounded-md"
              name={@name}
              value={@value}
              {@rest}
            />
            <p
              :if={assigns[:error] && assigns[:error] != ""}
              class="absolute block text-danger text-xs mt-1"
            >
              <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "number", field: nil, step: _} = assigns) do
    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <.label :if={assigns[:label]} for={@id} size={@size}>{@label}</.label>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={check_float_to_string(@value)}
          class={[
            input_class(@size, @type),
            @errors == [] && "border-zinc-300 focus:border-zinc-400",
            @errors != [] && "border-danger focus:border-danger"
          ]}
          step={@step}
          {@rest}
        />
        <.error :for={msg <- @errors}>{msg}</.error>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "number", field: nil} = assigns) do
    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <.label :if={assigns[:label]} for={@id} size={@size}>{@label}</.label>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={check_float_to_string(@value)}
          class={[
            input_class(@size, @type),
            @errors == [] && "border-zinc-300 focus:border-zinc-400",
            @errors != [] && "border-danger focus:border-danger"
          ]}
          {@rest}
        />
        <.error :for={msg <- @errors}>{msg}</.error>
      </div>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def waw_input(%{field: nil} = assigns) do
    ~H"""
    <div class={hidden_class(@visible)}>
      <div phx-feedback-for={@name}>
        <.label :if={assigns[:label]} for={@id} size={@size}>{@label}</.label>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            input_class(@size, @type),
            @errors == [] && "border-zinc-300 focus:border-zinc-400",
            @errors != [] && "border-danger focus:border-danger"
          ]}
          {@rest}
        />
        <.error :for={msg <- @errors}>{msg}</.error>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "color"} = assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="relative">
        <div class="flex flex-row items-center">
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <div class="relative ml-2">
            <input id={@id} type={@type} name={@name} value={@value} {@rest} />
            <p
              :if={assigns[:error] && assigns[:error] != ""}
              class="absolute block text-danger text-xs mt-1"
            >
              <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "text"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)
      |> assign_new(:placeholder, fn -> assigns[:placeholder] end)
      |> assign_new(:textarea_value, fn -> assigns[:textarea_value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div :if={@text_type == "email"}>
        <div class="relative">
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <div class="relative">
            <div class={icon_container()}>
              <.waw_icon name="envelope" size={icon_size(@size)} stroke="none" />
            </div>
            <input
              type="email"
              id={@id}
              class={[input_class(@size, "email"), @error_class]}
              placeholder={@placeholder}
              name={@name}
              value={@value}
              {@rest}
            />
            <p
              :if={assigns[:error] && assigns[:error] != ""}
              class="absolute block text-danger text-xs mt-1"
            >
              <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
            </p>
          </div>
        </div>
      </div>
      <div :if={@text_type == "textarea"}>
        <div>
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <textarea
            :if={assigns[:textarea_value] && assigns[:textarea_value] != ""}
            class={[textarea_class(@size), @error_class]}
            placeholder={@placeholder}
            name={@name}
            {@rest}
          ><%= @textarea_value %></textarea>
          <textarea
            :if={assigns[:textarea_value] == "" || assigns[:textarea_value] == nil}
            class={[textarea_class(@size), @error_class]}
            placeholder={@placeholder}
            name={@name}
            {@rest}
          />
          <p
            :if={assigns[:error] && assigns[:error] != ""}
            class="block text-danger text-xs mt-1"
          >
            <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
          </p>
        </div>
      </div>
      <div :if={@text_type != "email" && @text_type != "textarea"}>
        <div>
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <span :if={@tooltip_is_visible}>
            {render_slot(@tooltip_block)}
          </span>
          <div class="flex rounded-md">
            <span
              :if={@add_on}
              class={[
                "px-4 inline-flex items-center rounded-s-md border bg-default border-e-0 border-default-primary",
                @add_on && "text-" <> @size
              ]}
            >
              {@add_on_text}
            </span>
            <input
              type={@text_type}
              class={[
                input_class(@size),
                @error_class,
                @add_on == true && "block rounded-e-md",
                @add_on == false && "border rounded border-default"
              ]}
              id={@id}
              placeholder={@placeholder}
              name={@name}
              value={@value}
              {@rest}
            />
            <p
              :if={assigns[:error] && assigns[:error] != ""}
              class="block text-danger text-xs mt-1"
            >
              <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "number"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="relative">
        <div>
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <div class="relative">
            <div :if={Map.has_key?(assigns, :icon)} class={icon_container()}>
              <.waw_icon name={@icon} size={icon_size(@size)} stroke="none" />
            </div>
            <input
              :if={assigns[:step] && assigns[:list]}
              id={@id}
              type={@type}
              class={input_class_attr(Map.has_key?(assigns, :icon), @size, @error_class)}
              name={@name}
              value={@value}
              step={@step}
              max={@max}
              min={@min}
              list={@list}
              placeholder={@placeholder}
              {@rest}
            />
            <input
              :if={!assigns[:step] || !assigns[:list]}
              id={@id}
              type={@type}
              class={input_class_attr(Map.has_key?(assigns, :icon), @size, @error_class)}
              name={@name}
              value={@value}
              {@rest}
            />
            <p
              :if={assigns[:error] && assigns[:error] != ""}
              class="absolute block text-danger text-xs mt-1"
            >
              <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "password"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="relative">
        <div>
          <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
            {@label}
          </label>
          <div class="relative">
            <div class="absolute pt-0.5 inset-y-0 right-2.5 flex items-center text-dark z-20">
              {render_slot(@inner_block)}
            </div>
            <input
              id={@id}
              type={password_text_type(@password_is_visible)}
              class={password_class(@size)}
              name={@name}
              value={@value}
              {@rest}
            />
            <p
              :if={assigns[:error] && assigns[:error] != ""}
              class="absolute block text-danger text-xs mt-1"
            >
              <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "time"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="w-28">
        <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
          {@label}
        </label>
        <input
          id={@id}
          type="time"
          class={[
            input_class(@size),
            @error_class,
            "border rounded border-default"
          ]}
          name={@name}
          value={@value}
          {@rest}
        />
        <p
          :if={assigns[:error] && assigns[:error] != ""}
          class="block text-danger text-xs mt-1"
        >
          <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
        </p>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "date"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="w-36">
        <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
          {@label}
        </label>
        <input
          id={@id}
          type="date"
          class={[
            input_class(@size),
            @error_class,
            "border rounded border-default"
          ]}
          name={@name}
          value={@value}
          {@rest}
        />
        <p
          :if={assigns[:error] && assigns[:error] != ""}
          class="block text-danger text-xs mt-1"
        >
          <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
        </p>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "datetime-local"} = assigns) do
    error_class =
      if assigns[:error] && assigns[:error] != "", do: error_class(), else: ""

    assigns =
      assign(assigns, :error_class, error_class)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={hidden_class(@visible)}>
      <div class="w-44">
        <label :if={assigns[:label]} for={@id} class={"text-" <> @size}>
          {@label}
        </label>
        <input
          id={@id}
          type="datetime-local"
          class={[
            input_class(@size),
            @error_class,
            "border rounded border-default"
          ]}
          name={@name}
          value={@value}
          {@rest}
        />
        <p
          :if={assigns[:error] && assigns[:error] != ""}
          class="block text-danger text-xs mt-1"
        >
          <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" /> {@error}
        </p>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "search_without_border"} = assigns) do
    assigns =
      assigns
      |> assign_new(:placeholder, fn -> "Rechercher" end)
      |> assign_new(:name, fn -> assigns[:name] end)
      |> assign_new(:value, fn -> assigns[:value] end)

    ~H"""
    <div class={[
      if @visible do
        "relative"
      else
        "hidden"
      end
    ]}>
      <div class="w-full border border-t-0">
        <div class="absolute pt-0.5 inset-y-0 w-10 ml-2.5 flex items-center justify-center pointer-events-none text-dark">
          <.waw_icon
            name="magnifyingglass-search"
            size={icon_size(@size)}
            stroke="none"
          />
        </div>
        <div class="w-full px-0.5">
          <input
            type="search"
            id={@id}
            class="pl-14 mt-0 input input-primary w-full border-transparent placeholder-default-lite text-sm text-dark"
            placeholder={@placeholder}
            name={@name}
            value={@value}
            {@rest}
          />
        </div>
      </div>
      <div
        :if={@popup_is_visible}
        class="absolute bg-default top-10 left-0 mt-0.5 w-full h-auto z-50 rounded"
      >
        <ul>
          {render_slot(@inner_block)}
        </ul>
      </div>
    </div>
    """
  end

  def waw_input(%{type: "search"} = assigns) do
    assigns =
      assigns
      |> assign_new(:placeholder, fn -> "Rechercher" end)

    ~H"""
    <form class={hidden_class(@visible)}>
      <div class="relative">
        <div class={icon_container()}>
          <.waw_icon
            name="magnifyingglass-search"
            size={icon_size(@size)}
            stroke="none"
          />
        </div>
        <input
          type="search"
          id={@id}
          class={[input_class(@size, "search")]}
          placeholder={@placeholder}
          {@rest}
        />
      </div>
    </form>
    """
  end

  @deprecated "Use `waw_input/1`"
  defdelegate input(assigns), to: __MODULE__, as: :waw_input

  @doc """
  Renders a label.
  """
  attr(:for, :string, default: nil)
  attr(:size, :string)
  slot(:inner_block, required: true)

  def waw_label(assigns) do
    assigns =
      assigns
      |> assign(:size, assigns[:size] || "sm")

    ~H"""
    <label for={@for} class={"ml-0.5 mb-2 text-#{@size} font-medium text-dark"}>
      {render_slot(@inner_block)}
    </label>
    """
  end

  @deprecated "Use `waw_label/1`"
  defdelegate label(assigns), to: __MODULE__, as: :waw_label

  @doc """
  Generates a generic error message.
  """
  slot(:inner_block, required: true)

  def waw_error(assigns) do
    ~H"""
    <p class="block text-danger text-xs mt-1 phx-no-feedback:hidden">
      <.waw_icon name="exclamationmark-circle-fill" size="3" stroke="none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @deprecated "Use `waw_error/1`"
  defdelegate error(assigns), to: __MODULE__, as: :waw_error

  defp icon_container() do
    "absolute pt-0.5 inset-y-0 left-2.5 flex items-center pointer-events-none text-dark"
  end

  defp input_class_attr(has_icon, size, error_class) do
    case has_icon do
      false ->
        [input_class(size), error_class, "border rounded border-default"]

      _ ->
        [input_class(size, "phone"), error_class]
    end
  end

  defp icon_size("lg"), do: "w-4 h-4"
  defp icon_size(_), do: "w-3 h-3"

  defp password_text_type(true), do: "text"
  defp password_text_type(_), do: "password"

  # size 2 parameters
  defp input_class("xs", _),
    do:
      "block w-full p-1.5 pl-7 placeholder:italic text-xs text-dark border rounded border-default"

  defp input_class("sm", _),
    do: "block w-full p-1 pl-7 placeholder:italic text-sm text-dark border rounded border-default"

  defp input_class("md", _),
    do:
      "block w-full p-1.5 pl-8 placeholder:italic text-sm text-dark border rounded border-default focus:ring-dark"

  defp input_class("lg", _),
    do:
      "block w-full p-2 pl-8 placeholder:italic text-base text-dark border rounded border-default focus:ring-dark"

  # size one parameter
  defp input_class("xs"),
    do: "w-full p-1.5 pl-3 placeholder:italic text-xs text-dark"

  defp input_class("sm"),
    do: "w-full p-1 pl-3 placeholder:italic text-sm text-dark"

  defp input_class("md"),
    do: "w-full p-1.5 pl-4 placeholder:italic text-sm text-dark focus:ring-dark"

  defp input_class("lg"),
    do: "w-full p-2 pl-4 placeholder:italic text-base text-dark focus:ring-dark"

  # size password
  defp password_class("xs"),
    do: "block w-full p-1.5 pr-7 text-xs text-dark border rounded border-default"

  defp password_class("sm"),
    do: "block w-full p-1 pr-7 text-sm text-dark border rounded border-default"

  defp password_class("md"),
    do: "block w-full p-1.5 pr-8 text-sm text-dark border rounded border-default"

  defp password_class("lg"),
    do: "block w-full p-2 pr-8 text-base text-dark border rounded border-default"

  # size textarea
  defp textarea_class("xs"),
    do:
      "block w-full pb-3 pl-2 placeholder:italic text-xs text-dark border rounded border-default"

  defp textarea_class("sm"),
    do:
      "block w-full pb-5 pl-3 placeholder:italic text-sm text-dark border rounded border-default"

  defp textarea_class("md"),
    do:
      "block w-full pb-5 pl-3 placeholder:italic text-sm text-dark border rounded border-default"

  defp textarea_class("lg"),
    do:
      "block w-full pb-7 pl-4 placeholder:italic text-base text-dark border rounded border-default focus:ring-dark"

  defp error_class(),
    do: "border border-danger focus:ring-0"

  defp hidden_class(visible) do
    if visible do
      ""
    else
      "hidden"
    end
  end

  # defp format_float_to_string(value) do
  #   case is_float(value) do
  #     true ->
  #       :erlang.float_to_binary(value, decimals: 1)
  #
  #     false ->
  #       value
  #   end
  # end

  defp check_float_to_string(value) do
    case is_float(value) do
      true ->
        check_to_string(value)

      false ->
        value
    end
  end

  defp check_to_string(value) do
    if Regex.match?(~r/e/, Float.to_string(value)) ||
         Regex.match?(~r/\.0\z/, Float.to_string(value)) do
      :erlang.float_to_binary(value, decimals: 0)
    else
      value
    end
  end
end

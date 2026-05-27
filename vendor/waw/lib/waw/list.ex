defmodule Waw.List do
  @moduledoc """
    Afficher une liste de groupe d'éléments.
  """
  use Phoenix.Component
  import Waw.Icons
  import Waw.Templates.IconTitleAction

  attr(:text_size, :string,
    values: ["xs", "sm", "base"],
    default: "sm"
  )

  slot(:inner_block)

  @doc """
  Definir une liste non ordonnée

  ## Usage
  ```heex
    <.waw_ul>
      ...
    </.waw_ul>
  ```
  """
  def ul(assigns) do
    ~H"""
    <ul class={"bg-base-100 mt-px grow overflow-y-auto overflow-x-hidden text-#{@text_size}"}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  slot(:inner_block, required: true)

  attr(:state, :string,
    default: "normal",
    values: ["normal", "selected", "alert"]
  )

  attr(:title, :string, default: "")
  attr(:icon, :string)
  attr(:total, :integer)
  attr(:is_title, :boolean, default: false)

  attr(:battery_number, :integer)
  attr(:battery_charging, :boolean, default: false)
  attr(:battery_indisponible, :boolean, default: false)

  attr(:connexion_status, :string, default: nil)
  # values: [
  #   nil,
  #   "low",
  #   "offline",
  #   "defective",
  #   "unknown",
  #   "moving",
  #   "parked",
  #   "no_activity",
  #   "low_activity",
  #   "high_activity",
  #   "power_off"
  # ]

  attr(:lock_status, :string, default: nil, values: [nil, "locked", "unlocked"])
  attr(:acronym, :string)
  attr(:rest, :global)

  @doc """
  Les elements de la liste `li`.

  ## Usage

  ```heex
    <.waw_li icon="person-fill" battery_number={20} connexion_status="normal">item 1</.waw_li>
    <.waw_li icon="person-fill" state="selected"  battery_number={40} connexion_status="low">item 2</.waw_li>
    <.waw_li icon="boat" connexion_status="moving">item 3</.waw_li>
    <.waw_li icon="moto" connexion_status="offline">item 4</.waw_li>
    <.waw_li icon="truck" state="selected" connexion_status="parked">item 5</.waw_li>
    <.waw_li icon="car" connexion_status="defective">item 6</.waw_li>
    <.waw_li icon="car" connexion_status="moving">item 7</.waw_li>
    <.waw_li icon="person-fill" state="alert" battery_number={30} connexion_status="offline">item 8</.waw_li>
    <.waw_li icon="person-fill" battery_number={75} connexion_status="low_activity">item 9</.waw_li>
    <.waw_li icon="person-fill" battery_number={50} connexion_status="high_activity">item 10</.waw_li>
    <.waw_li icon="person-fill" state="selected" battery_number={80} connexion_status="no_activity">item 11</.waw_li>
    <.waw_li icon="person-fill" battery_number={80} connexion_status="power_off">item 12</.waw_li>
    <.waw_li icon="lock-close-fill" lock_status="locked" battery_number={50} connexion_status="offline">item 13</.waw_li>
    <.waw_li icon="lock-close-fill" state="selected" lock_status="unlocked" battery_number={30} connexion_status="high_activity">item 14</.waw_li>
    <.waw_li icon="lock-close-fill" lock_status="locked" battery_number={50} connexion_status="low_activity">item 15</.waw_li>
    <.waw_li icon="lock-close-fill" lock_status="unlocked" battery_number={30} connexion_status="no_activity">item 16</.waw_li>
    <.waw_li icon="lock-close-fill" title="MD11802/DMY0029" lock_status="unlocked" battery_number={0} connexion_status="defective">item 17</.waw_li>
  ```
  """

  def li(assigns) do
    ~H"""
    <li
      :if={assigns[:icon]}
      class={[li_class(@state, assigns[:acronym]), font_class(@is_title)]}
      title={@title}
      {@rest}
    >
      <.waw_icon_title_action icon_box_size="6">
        <:icon>
          <div
            :if={assigns[:icon]}
            class="flex items-center justify-center ml-4 w-10"
          >
            <.waw_icon name={@icon} stroke="none" />
          </div>
        </:icon>
        <:label>
          <div class="truncate w-full">
            {render_slot(@inner_block)}
          </div>
        </:label>
        <:action>
          <div
            :if={assigns[:state] === "alert"}
            class="w-8 flex-none flex items-center justify-center"
          >
            <span title="SOS">
              <.waw_icon name="sos-circle-fill" stroke="none" />
            </span>
          </div>
          <div
            :if={assigns[:battery_number] && assigns[:battery_charging]}
            class="w-8 flex-none flex items-center justify-center"
          >
            <span title="En charge">
              <.waw_icon
                name={"battery-" <> battery_icon(@battery_number)}
                stroke="none"
              />
            </span>
          </div>
          <div
            :if={assigns[:battery_number] && !assigns[:battery_charging]}
            class="w-8 flex-none flex items-center justify-center"
          >
            <span title={to_string(@battery_number) <> "%"}>
              <.waw_icon
                name={"battery-" <> battery_icon(@battery_number)}
                stroke="none"
              />
            </span>
          </div>
          <div
            :if={assigns[:battery_indisponible] && is_nil(assigns[:battery_number])}
            class="w-8 flex-none flex items-center justify-center"
          >
            <span title="Indisponible">
              <.waw_icon name="battery-100" stroke="none" />
            </span>
          </div>
          <div
            :if={
              assigns[:connexion_status] in [
                "normal",
                "low",
                "offline",
                "defective",
                "unknown",
                "power_off"
              ] and
                not is_nil(assigns[:connexion_status])
            }
            title={tooltip(@connexion_status)}
            class={"#{icon_color(@connexion_status)} w-8 flex-none flex items-center justify-center"}
          >
            <.waw_icon name={connexion_status(@connexion_status)} stroke="none" />
          </div>
          <div
            :if={
              assigns[:connexion_status] in [
                "moving",
                "parked",
                "no_activity",
                "low_activity",
                "high_activity"
              ]
            }
            title={tooltip(@connexion_status)}
            class="w-8 flex-none flex items-center justify-center"
          >
            <div class={"w-3 h-1 #{small_status_properties_color(@connexion_status)} rounded"}></div>
          </div>
          <div
            :if={assigns[:lock_status] in ["locked", "unlocked", "unknown"]}
            title={tooltip(@lock_status)}
            class={"#{lock_status_color(@lock_status)} w-8 flex-none flex items-center justify-center"}
          >
            <span>
              <.waw_icon name={lock_status(@lock_status)} stroke="none" />
            </span>
          </div>
          <div
            :if={assigns[:total]}
            class="w-8 flex-none flex items-center justify-center"
          >
            <span>
              {@total}
            </span>
          </div>
        </:action>
      </.waw_icon_title_action>
    </li>
    <li
      :if={assigns[:acronym]}
      class={[li_class(@state, assigns[:acronym]), font_class(@is_title)]}
      title={@title}
      {@rest}
    >
      <.waw_icon_title_action icon_box_size="6">
        <:icon>
          <div :if={assigns[:acronym]} class="ml-2 w-10">
            <div class={acronym_section(@state)}>
              {@acronym}
            </div>
          </div>
        </:icon>
        <:label>
          <div class="truncate w-full">
            {render_slot(@inner_block)}
          </div>
        </:label>
      </.waw_icon_title_action>
    </li>
    <li
      :if={!assigns[:icon] and !assigns[:acronym]}
      class={[li_class(@state), font_class(@is_title)]}
      title={@title}
      {@rest}
    >
      <div class="flex flex-row">
        <div class="truncate w-full">
          {render_slot(@inner_block)}
        </div>
        <div class="flex items-center">
          <div
            :if={
              assigns[:connexion_status] in [
                "normal",
                "low",
                "offline",
                "defective",
                "unknown",
                "power_off"
              ] and
                not is_nil(assigns[:connexion_status])
            }
            title={tooltip(@connexion_status)}
            class={"#{icon_color(@connexion_status)} w-8 flex-none flex items-center justify-center"}
          >
            <.waw_icon name={connexion_status(@connexion_status)} stroke="none" />
          </div>
          <div
            :if={
              assigns[:connexion_status] in [
                "moving",
                "parked",
                "no_activity",
                "low_activity",
                "high_activity"
              ]
            }
            title={tooltip(@connexion_status)}
            class="w-8 flex-none flex items-center justify-center"
          >
            <div class={"w-3 h-1 #{small_status_properties_color(@connexion_status)} rounded"}></div>
          </div>
          <div
            :if={
              assigns[:connexion_status] not in [
                "normal",
                "low",
                "offline",
                "defective",
                "unknown",
                "power_off",
                "moving",
                "parked",
                "no_activity",
                "low_activity",
                "high_activity"
              ] and
                not is_nil(assigns[:connexion_status]) and
                assigns[:lock_status] not in ["locked", "unlocked"]
            }
            title=""
            class={"#{icon_color(@connexion_status)} w-8 flex-none flex items-center justify-center"}
          >
            <.waw_icon name={@connexion_status} stroke="none" />
          </div>
          <div
            :if={assigns[:lock_status] in ["locked", "unlocked", "unknown"]}
            title={tooltip(@lock_status)}
            class={"#{lock_status_color(@lock_status)} w-8 flex-none flex items-center justify-center"}
          >
            <span>
              <.waw_icon name={lock_status(@lock_status)} stroke="none" />
            </span>
          </div>
          <div
            :if={assigns[:total]}
            class="w-8 flex-none flex items-center justify-center"
          >
            <span>
              {@total}
            </span>
          </div>
        </div>
      </div>
    </li>
    """
  end

  defp icon_color("offline"), do: "text-default-lite"
  defp icon_color("defective"), do: "text-default-primary"
  defp icon_color(_), do: "text-default-primary"

  defp connexion_status("low"), do: "wifi-exclamationmark"

  defp connexion_status(status)
       when status in ["offline", "defective", "unknown"] do
    "wifi-slash"
  end

  defp connexion_status("power_off"), do: "power"
  defp connexion_status(_), do: "wifi"

  defp lock_status("unlocked"), do: "lock-open-fill"
  defp lock_status("locked"), do: "lock-close-fill"
  defp lock_status(_), do: "lock-close-fill"

  defp lock_status_color("unlocked"), do: "text-danger"
  defp lock_status_color("locked"), do: "text-success"
  defp lock_status_color(_), do: "text-default-primary"

  defp tooltip(status) do
    case status do
      "offline" -> "Déconnectée"
      "defective" -> "Défectueux"
      "unknown" -> "Inconnu"
      "power_off" -> "Eteint"
      "moving" -> "En mouvement"
      "parked" -> "À l'arrêt"
      "no_activity" -> "Sans activité"
      "low_activity" -> "Basse activité"
      "high_activity" -> "Haute activité"
      "locked" -> "Verrouillé"
      "unlocked" -> "Déverrouillé"
      _ -> "Défectueux"
    end
  end

  defp battery_icon("battery_charging") do
    # "battery_charging"
  end

  defp battery_icon(battery_level)
       when battery_level < 20 do
    "0"
  end

  defp battery_icon(battery_level)
       when battery_level >= 20 and battery_level < 41 do
    "30"
  end

  defp battery_icon(battery_level)
       when battery_level >= 41 and battery_level < 61 do
    "50"
  end

  defp battery_icon(battery_level)
       when battery_level >= 61 and battery_level < 91 do
    "75"
  end

  defp battery_icon(battery_level)
       when battery_level >= 91 do
    "100"
  end

  defp battery_icon(_) do
    "100"
    # gettext("Indisponible")
  end

  defp small_status_properties_color(status)
       when status in ["moving", "high_activity"] do
    "bg-success"
  end

  defp small_status_properties_color(status)
       when status in ["parked", "no_activity"] do
    "bg-danger"
  end

  defp small_status_properties_color("low_activity"), do: "bg-orange"

  defp li_class("selected", acronym) when is_nil(acronym),
    do:
      "flex flex-row items-center justify-center text-info border border-info hover:bg-primary rounded-md h-9 cursor-pointer"

  defp li_class("selected", _),
    do:
      "flex flex-row items-center justify-center text-info border border-white hover:bg-primary rounded-md h-9 cursor-pointer"

  defp li_class("normal", _acronym),
    do:
      "flex flex-row items-center justify-center text-dark border border-white hover:bg-primary rounded-md h-9 cursor-pointer w-full"

  defp li_class("alert", _acronym),
    do:
      "flex flex-row items-center justify-center text-danger border border-danger hover:bg-primary rounded-md h-9 cursor-pointer"

  defp li_class(state) do
    case state do
      "selected" ->
        "h-9 hover:bg-white mx-px my-0.5 pt-2.5 pl-4 text-info border border-info rounded-md cursor-pointer"

      "alert" ->
        "h-9 hover:bg-white mx-px my-0.5 pt-2.5 pl-4 text-danger border border-danger rounded-md cursor-pointer"

      _ ->
        "h-9 hover:bg-white mx-px my-0.5 pt-2.5 pl-4 text-dark rounded-md cursor-pointer"
    end
  end

  defp font_class(true), do: "font-bold"
  defp font_class(_), do: "font-medium"

  defp acronym_section("selected"),
    do:
      "bg-info h-6 w-6 rounded-full flex items-center justify-center hover:bg-info-primary text-lite ml-2.5"

  defp acronym_section(_),
    do:
      "bg-lite h-6 w-6 rounded-full flex items-center justify-center hover:bg-default text-black ml-2.5"
end

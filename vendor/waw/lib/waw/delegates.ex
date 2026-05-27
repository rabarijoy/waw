defmodule Waw.Delegates do
  @moduledoc """
  Documentation for `Waw`.
  """

  defdelegate waw_navbar(assigns), to: Waw.Header
  defdelegate waw_accordion(assigns), to: Waw.Accordion
  defdelegate waw_badge(assigns), to: Waw.Badge
  defdelegate waw_button(assigns), to: Waw.Button
  defdelegate waw_card(assigns), to: Waw.Card
  defdelegate waw_time_section(assigns), to: Waw.Card
  defdelegate waw_date_section(assigns), to: Waw.Card
  defdelegate waw_dl(assigns), to: Waw.DefinitionList

  defdelegate waw_definition(assigns), to: Waw.DefinitionList

  @spec waw_footer(map()) :: Phoenix.LiveView.Rendered.t()
  defdelegate waw_footer(assigns), to: Waw.Footer
  defdelegate waw_icons(assigns), to: Waw.Icons, as: :waw_icon
  defdelegate waw_input(assigns), to: Waw.Input, as: :waw_input
  defdelegate waw_ul(assigns), to: Waw.List, as: :ul
  defdelegate waw_li(assigns), to: Waw.List, as: :li
  defdelegate waw_list_header(assigns), to: Waw.ListHeader

  defdelegate waw_panel_header(assigns), to: Waw.PanelHeader

  defdelegate waw_table(assigns), to: Waw.Table
  defdelegate waw_thead(assigns), to: Waw.Table
  defdelegate waw_th(assigns), to: Waw.Table
  defdelegate waw_tr(assigns), to: Waw.Table
  defdelegate waw_td(assigns), to: Waw.Table
  defdelegate waw_th_icon(assigns), to: Waw.Table
  defdelegate waw_td_icon(assigns), to: Waw.Table
  defdelegate waw_tabs(assigns), to: Waw.Tabs
  defdelegate waw_tab(assigns), to: Waw.Tabs
  defdelegate waw_tooltip(assigns), to: Waw.Tooltip, as: :tooltip
  defdelegate waw_loading(assigns), to: Waw.Loading, as: :waw_loading
  defdelegate waw_link_icon(assigns), to: Waw.Link
  defdelegate waw_link_text(assigns), to: Waw.Link
  defdelegate waw_live_search(assigns), to: Waw.LiveSearch
  defdelegate waw_list_group(assigns), to: Waw.LiveSearch

  defdelegate waw_filter_header(assigns), to: Waw.FilterHeader
  defdelegate waw_nav_filter(assigns), to: Waw.FilterHeader
  defdelegate waw_live_button(assigns), to: Waw.LiveButton, as: :live_button
  defdelegate waw_li_button(assigns), to: Waw.LiveButton, as: :li_button
  defdelegate waw_dashboard(assigns), to: Waw.Dashboard

  defdelegate waw_dashboard_table(assigns), to: Waw.Dashboard

  defdelegate waw_dashboard_td(assigns), to: Waw.Dashboard

  defdelegate waw_dashboard_list(assigns), to: Waw.Dashboard

  defdelegate waw_dashboard_li(assigns), to: Waw.Dashboard

  defdelegate waw_stat(assigns), to: Waw.Stat
  defdelegate waw_name(assigns), to: Waw.TrackableName

  defdelegate waw_dashboard_card(assigns), to: Waw.DashboardCard

  defdelegate waw_time(assigns), to: Waw.Text.Dates, as: :time
  defdelegate waw_interval(assigns), to: Waw.Text.Dates

  defdelegate waw_relative_time(assigns), to: Waw.Text.Dates

  defdelegate waw_date(assigns), to: Waw.Text.Dates
  defdelegate waw_date_time(assigns), to: Waw.Text.Dates
  defdelegate waw_text(assigns), to: Waw.Text.Text, as: :text
  defdelegate waw_distance(assigns), to: Waw.Text.Number, as: :distance
  defdelegate waw_number(assigns), to: Waw.Text.Number, as: :number
  defdelegate waw_currency(assigns), to: Waw.Text.Number, as: :currency

  defdelegate waw_typography(assigns),
    to: Waw.Styleguide.Typograghy,
    as: :typography

  defdelegate waw_map_header(assigns), to: Waw.MapHeader, as: :map_header
  defdelegate waw_button_icon(assigns), to: Waw.Clickable
  defdelegate waw_button_text(assigns), to: Waw.Clickable

  defdelegate waw_subheader(assigns), to: Waw.Subheader
  defdelegate waw_map_footer(assigns), to: Waw.MapFooter, as: :map_footer

  @spec waw_notification_popup(map()) :: Phoenix.LiveView.Rendered.t()
  defdelegate waw_notification_popup(assigns),
    to: Waw.NotificationPopup,
    as: :notification_popup

  defdelegate waw_head_section(assigns),
    to: Waw.MapFooter,
    as: :head_section

  defdelegate waw_content(assigns), to: Waw.MapFooter, as: :content
  defdelegate waw_section(assigns), to: Waw.MapFooter, as: :section
  defdelegate waw_status_card(assigns), to: Waw.StatusCard

  defdelegate waw_status_block(assigns), to: Waw.StatusBlock
  defdelegate waw_status_block_content(assigns), to: Waw.StatusBlock

  defdelegate waw_modal(assigns), to: Waw.Modal
  defdelegate waw_contenteditable(assigns), to: Waw.Contenteditable
  defdelegate waw_tag_list(assigns), to: Waw.TagList

  defdelegate waw_layout_3s(assigns),
    to: Waw.Layouts.Layout3s,
    as: :layout_3s

  defdelegate waw_layout_2s(assigns),
    to: Waw.Layouts.Layout2s,
    as: :layout_2s

  defdelegate waw_page_error(assigns),
    to: Waw.Pages.PageError

  defdelegate waw_grid(assigns),
    to: Waw.Layouts.Forms,
    as: :grid

  defdelegate waw_forms(assigns),
    to: Waw.Layouts.Forms,
    as: :forms

  defdelegate waw_fixed_header_footer(assigns),
    to: Waw.Templates.FixedHeaderFooter

  defdelegate waw_nav_breadcrumb(assigns), to: Waw.Subheader

  defdelegate waw_flash(assigns),
    to: Waw.Flash,
    as: :flash

  defdelegate waw_flash_group(assigns),
    to: Waw.Flash,
    as: :flash_group

  defdelegate waw_checkbox_list(assigns),
    to: Waw.CheckboxList
end

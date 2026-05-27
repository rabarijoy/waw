defmodule Waw.Text.TextHelper do
  @moduledoc """
  Helpers pour les dates
  """

  require Logger

  def text(value) do
    if is_nil(value) do
      {:safe, "&mdash;"}
    else
      value
    end
  end
end

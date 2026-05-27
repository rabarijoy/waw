defmodule Waw do
  @moduledoc """
  Documentation for `Waw`.
  """

  defmacro __using__(_) do
    quote do
      import Waw.Delegates
      import Waw.Header, except: [header: 1]
      import Waw.Steps
      import Waw.Pagination
      import Waw.BlockTitle
      import Waw.BlockSeparator
      import Waw.ButtonGroup
      import Waw.BlockListContainer
    end
  end
end

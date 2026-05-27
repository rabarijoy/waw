defmodule Waw.Loading do
  @moduledoc """
   Loading
  """
  use Phoenix.Component

  @doc """
  Loading lors d'un chargement de page.

  ## Usage

  ```
    <.waw_loading />
  ```
  """

  def waw_loading(assigns) do
    ~H"""
    <div class="w-full h-full grid place-content-center">
      <div
        class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-current border-r-transparent text-info align-[-0.125em] motion-reduce:animate-[spin_1.5s_linear_infinite]"
        role="status"
      >
        <span class="!absolute !-m-px !h-px !w-px !overflow-hidden !whitespace-nowrap !border-0 !p-0 ![clip:rect(0,0,0,0)]">
          Loading...
        </span>
      </div>
    </div>
    """
  end

  @deprecated "Use `#{__MODULE__}.waw_loading/1`"
  defdelegate loading(assigns), to: __MODULE__, as: :waw_loading
end

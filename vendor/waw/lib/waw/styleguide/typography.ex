defmodule Waw.Styleguide.Typograghy do
  @moduledoc """
  Afficher le Typography
  """
  use Phoenix.Component

  slot(:inner_block)

  @doc """
  Afficher le typography

  ## Usage
  ```
    <.h1>Text</.h1>
    <.h2>Text</.h2>
    <.h3>Text</.h3>
    <.h4>Text</.h4>
    <.h5>Text</.h5>
    <.h6>Text</.h6>
    <.title>Text</.title>
    <.subtitle>Text</.subtitle>
    <.p>Text</.p>
  ```
  """

  def typography(assigns) do
    ~H"""
    <div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage h1.

  ## Usage
    ```
    <.h1>Text</.h1>
    ```
  """
  def h1(assigns) do
    ~H"""
    <h1 class="text-6xl font-bold" {@rest}>{render_slot(@inner_block)}</h1>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage h2.

  ## Usage
    ```
    <.h2>Text</.h2>
    ```
  """
  def h2(assigns) do
    ~H"""
    <h2 class="text-5xl font-bold" {@rest}>{render_slot(@inner_block)}</h2>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage h3.

  ## Usage
    ```
    <.h3>Text</.h3>
    ```
  """
  def h3(assigns) do
    ~H"""
    <h3 class="text-4xl font-bold" {@rest}>{render_slot(@inner_block)}</h3>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage h4.

  ## Usage
    ```
    <.h4>Text</.h4>
    ```
  """

  def h4(assigns) do
    ~H"""
    <h4 class="text-3xl font-bold" {@rest}>{render_slot(@inner_block)}</h4>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage h5.

  ## Usage
    ```
    <.h5>Text</.h5>
    ```
  """
  def h5(assigns) do
    ~H"""
    <h5 class="text-2xl font-bold" {@rest}>{render_slot(@inner_block)}</h5>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage h6.

  ## Usage
    ```
    <.h6>Text</.h6>
    ```
  """
  def h6(assigns) do
    ~H"""
    <h6 class="text-xl font-bold" {@rest}>{render_slot(@inner_block)}</h6>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage title.

  ## Usage
    ```
    <.title>Text</.title>
    ```
  """
  def title(assigns) do
    ~H"""
    <div class="text-base font-bold" {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage subtitle.

  ## Usage
    ```
    <.subtitle>Text</.subtitle>
    ```
  """
  def subtitle(assigns) do
    ~H"""
    <div class="text-sm" {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr(:rest, :global)
  slot(:inner_block)

  @doc """
  Affichage p.

  ## Usage
    ```
    <.pText</.p>
    ```
  """
  def p(assigns) do
    ~H"""
    <p class="text-xs" {@rest}>{render_slot(@inner_block)}</p>
    """
  end
end

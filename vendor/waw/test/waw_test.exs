defmodule WawTest do
  use ExUnit.Case
  doctest Waw

  test "greets the world" do
    assert Waw.hello() == :world
  end
end

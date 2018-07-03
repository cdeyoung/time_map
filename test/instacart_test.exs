defmodule InstacartTest do
  use ExUnit.Case
  doctest Instacart

  test "greets the world" do
    assert Instacart.hello() == :world
  end
end

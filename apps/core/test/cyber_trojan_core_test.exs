defmodule CyberTrojan.CoreTest do
  use ExUnit.Case
  doctest CyberTrojan.Core

  test "greets the world" do
    assert CyberTrojan.Core.hello() == :world
  end
end

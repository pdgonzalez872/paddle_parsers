defmodule PaddleParsersTest do
  use ExUnit.Case
  doctest PaddleParsers

  test "greets the world" do
    assert PaddleParsers.hello() == :world
  end
end

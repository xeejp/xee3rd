defmodule TokenGeneratorTest do
  use ExUnit.Case, async: true
  test "generate" do
    assert String.length(Xee3rd.TokenGenerator.generate) == 36
  end
end

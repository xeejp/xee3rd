defmodule AssertionTest do
  use ExUnit.Case, async: true
  test "generate_id test" do
    assert String.length(Xee3rd.Experiment.generate_id) == 6
  end
  test "generate_id test with arg" do
    assert String.length(Xee3rd.Experiment.generate_id 10) == 10
  end
end

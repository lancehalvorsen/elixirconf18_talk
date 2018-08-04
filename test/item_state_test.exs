defmodule Items.ItemStateTest do
  use ExUnit.Case

  alias Items.ItemState

  describe ".transition_to_pullable/1" do
    test "when in the cleaned state returns ok" do
      assert :ok == ItemState.transition_to_pullable(:cleaned)
    end

    test "when in the locked state returns an error" do
      assert :error == ItemState.transition_to_pullable(:locked)
    end

    test "when in the pullable state returns ok" do
      assert :ok == ItemState.transition_to_pullable(:pullable)
    end

    test "when in the pulled state returns ok" do
      assert :ok == ItemState.transition_to_pullable(:pulled)
    end

    test "when in the returned state returns ok" do
      assert :ok == ItemState.transition_to_pullable(:returned)
    end

    test "when in the shipped state returns ok" do
      assert :ok == ItemState.transition_to_pullable(:shipped)
    end

    test "when in some random state returns an error" do
      assert :error == ItemState.transition_to_pullable(:wrong)
    end
  end
end
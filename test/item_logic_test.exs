defmodule Items.LogicTest do
  use ExUnit.Case

  alias Items.{Data, Logic, Queries}

  setup do
    :ets.delete_all_objects(:items)
    item =
      4
      |> Data.new(:locked)
      |> Queries.create()
    {:ok, item: item}
  end

  describe ".set_location/2" do
    test "sets the location and returns the item with item struct and integer location id", %{item: item} do
      assert Logic.set_location(item, 3) == Map.put(item, :location_id, 3)
    end

    test "returns an error with an improper item struct" do
      assert :improper_item_struct == Logic.set_location(%{}, 5)
    end

    test "returns an error without an integer location_id", %{item: item} do
      assert :non_integer_location_id == Logic.set_location(item, "5")
    end
  end

  describe ".set_state/2" do
    test "sets the state and retruns the item struct with an items struct and proper state", %{item: item} do
      assert Logic.set_state(item, :pullable) == Map.put(item, :state, :pullable)
    end

    test "returns an error with an improper item struct" do
      assert :improper_item_struct == Logic.set_state(%{}, :pullable)
    end

    test "returns an error with an non-existant state" do
      assert :undefined_state == Logic.set_state(%{}, :wrong_state)
    end

    test "returns an error with an non-atom state" do
      assert :undefined_state == Logic.set_state(%{}, "pullable")
    end
  end
end
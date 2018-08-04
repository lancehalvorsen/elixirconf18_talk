defmodule Items.DataTest do
  use ExUnit.Case

  alias Items.Data

  describe ".new/3" do
    test "returns a filled out struct when all values passed in" do
      id = 7
      state = :locked
      location_id = 15
      assert %Data{id: id, state: state, location_id: location_id} == Data.new(id, state, location_id)
    end

    test "location id is not required" do
      id = 7
      state = :locked
      assert %Data{id: id, state: state, location_id: nil} == Data.new(id, state)
    end

    test "returns an error when the id is not an integer" do
      assert :non_integer_id == Data.new("7", :pullable)
    end

    test "returns an error when state not in allowed states" do
      assert :unknown_state == Data.new(7, :completely_wrong)
    end

    test "returns an error when location id is not an integer" do
      assert :non_integer_location_id == Data.new(7, :pullable, "15")
    end
  end
end
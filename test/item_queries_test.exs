defmodule Items.QueriesTest do
  use ExUnit.Case

  alias Items.{Data, Queries}

  setup do
    :ets.delete_all_objects(:items)
    item =
      3
      |> Data.new(:shipped)
      |> Queries.create()

    {:ok, item: item}
  end

  describe ".create/1" do
    test "inserts an item into ets when it's a new id" do
      id = 7
      assert item = Queries.create(Data.new(id, :cleaned))
      assert [{id, item}] == :ets.lookup(:items, id)
    end

    test "returns false when the id is a duplicate" do
      item = Data.new(9, :locked)
      assert item == Queries.create(item)
      assert :duplicate_item_error == Queries.create(item)
    end

    test "returns an error with an improper item struct" do
      assert :invalid_item_struct == Queries.create(%{})
    end
  end

  describe ".fectch/1" do
    test "returns the item given the id when item exists", %{item: item} do
      Queries.create(item)
      assert item == Queries.fetch(item.id)
    end

    test "returns an empty list when no such item exists" do
      assert [] == Queries.fetch(-17)
    end

    test "returns an empty list when id is not an integer", %{item: item} do
      id = Integer.to_string(item.id)
      assert [] == Queries.fetch(id)
    end
  end

  describe ".update/1" do
    test "sets the new value in ETS", %{item: item} do
      location_id = 1136
      item = Map.put(item, :location_id, location_id)
      updated_item = Queries.update(item)
      assert %Data{} = updated_item
      assert item == updated_item
    end

    test "returns an error if not passed an item struct" do
      assert :invalid_item_struct = Queries.update(3)
    end
  end
end
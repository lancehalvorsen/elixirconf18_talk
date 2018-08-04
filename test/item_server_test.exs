defmodule Items.DataServerTest do
  use ExUnit.Case

  alias Items.{Data, Queries, ItemServer}

  setup do
    :ets.delete_all_objects(:items)
    id = 1
    state = :pullable
    item = Data.new(id, state)
    Queries.create(item)
    {:ok, pid} = ItemServer.start_link(id)

    {:ok, id: id, pid: pid, state: state}
  end

  describe ".via/1" do
    test "returns the correct via tuple when id is an integer" do
      id = 907
      assert {:via, Registry, {Registry.Items, id}} == ItemServer.via(id)
    end

    test "retuns an error when id is not an integer" do
      assert :non_integer_id = ItemServer.via("856")
    end
  end

  describe "initialization" do
    test "starts a process", %{pid: pid} do
      assert is_pid(pid) == true
    end

    test "sets an item struct in state", %{id: id, pid: pid, state: state} do
      assert :sys.get_state(pid) == Data.new(id, state)
    end

    test "returns an error when the id is not an integer" do
      assert :non_integer_id = ItemServer.start_link("12")
    end
  end

  describe "registration" do
    test "starting a process registers that process", %{id: id, pid: pid} do
      via = ItemServer.via(id)
      assert GenServer.whereis(via) == pid
    end

    test "sending a message to a process starts that process", %{id: id} do
      new_id = id + 10
      Queries.create(%Data{id: new_id, state: :locked})
      via = ItemServer.via(new_id)
      assert :ok = ItemServer.set_location(via, 38)
    end
  end

  describe ".set_location/2 when state machine says transition state" do
    test "sets the location when the location id is an integer", %{pid: pid} do
      assert :ok == ItemServer.set_location(pid, 78)
      item = :sys.get_state(pid)
      assert item.location_id == 78
      assert item.state == :pullable
    end

    test "retuns an error when location id is not an integer", %{pid: pid} do
      assert :non_integer_location_id == ItemServer.set_location(pid, :seventy_eight)
      item = :sys.get_state(pid)
      assert item.location_id == nil
      assert item.state == :pullable
    end
  end

  describe ".set_location/2 when state machine says don't transition state" do
    test "sets the location but doesn't update the state" do
      id = 2
      state = :locked
      item = Data.new(id, state)
      Queries.create(item)
      {:ok, pid} = ItemServer.start_link(id)

      assert :ok == ItemServer.set_location(pid, 52)
      item = :sys.get_state(pid)
      assert item.location_id == 52
      assert item.state == :locked
    end
  end
end
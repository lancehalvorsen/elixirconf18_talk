defmodule Items.ItemSupervisorTest do
  use ExUnit.Case

  alias Items.{Data, Queries, ItemServer, ItemSupervisor}

  def stop_all_item_servers() do
    children = DynamicSupervisor.which_children(ItemSupervisor)
    Enum.each(children, fn child ->
     {_, pid, _, _} = child
     DynamicSupervisor.terminate_child(ItemSupervisor, pid)
    end)
    :ok
  end

  setup do
    id = 87
    via = ItemServer.via(id)

    id
    |> Data.new(:cleaned)
    |> Queries.create()

    on_exit(fn -> stop_all_item_servers() end)

    {:ok, via: via}
  end

  test "starts an ItemServer", %{via: via} do
    assert GenServer.whereis(via) == nil
    {:ok, pid} = ItemSupervisor.start_item_server(via)
    assert GenServer.whereis(via) == pid
  end

  test "stops and ItemServer", %{via: via} do
    {:ok, pid} = ItemSupervisor.start_item_server(via)
    assert GenServer.whereis(via) == pid
    :ok = ItemSupervisor.stop_item_server(via)
    assert GenServer.whereis(via) == nil
  end
end
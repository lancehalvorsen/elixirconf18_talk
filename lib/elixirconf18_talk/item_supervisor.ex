defmodule Items.ItemSupervisor do
  use DynamicSupervisor

  alias Items.ItemServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_item_server(via) do
    {:via, Registry, {Registry.Items, id}} = via
    child_spec = {ItemServer, id}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop_item_server(via) do
    via
    |> GenServer.whereis()
    |> (fn pid -> DynamicSupervisor.terminate_child(__MODULE__, pid) end).()
  end
end
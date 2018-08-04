defmodule Items.ItemServer do
  use GenServer, restart: :transient

  alias Items.{Logic, Queries, ItemState, ItemSupervisor}

  @default_timeout :timer.minutes(10)

  def via(id) when is_integer(id) do
    {:via, Registry, {Registry.Items, id}}
  end
  def via(_id), do: :non_integer_id

  def start_link(id) when is_integer(id) do
    GenServer.start_link(__MODULE__, id, name: via(id))
  end
  def start_link(_id), do: :non_integer_id

  def set_location(via, location_id) when is_integer(location_id) do
    call(via, {:set_location, location_id})
  end
  def set_location(_via, _location_id), do: :non_integer_location_id

  def init(id) do
    {:ok, id, {:continue, :init}}
  end

  def handle_continue(:init, id) do
    {:noreply, Queries.fetch(id)}
  end

  def handle_call({:set_location, location_id}, _from, item) do
    item =
      case ItemState.transition_to_pullable(item.state) do
        :ok ->
          item
          |> Logic.set_location(location_id)
          |> Logic.set_state(:pullable)
        :error ->
          Logic.set_location(item, location_id)
      end
    {:reply, :ok, Queries.update(item), @default_timeout}
  end

  def terminate({:shutdown, :timeout}, _state_data) do
    :ok
  end
  def terminate(_reason, _state), do: :ok

  def handle_info(:timeout, item) do
    {:stop, {:shutdown, :timeout}, item}
  end

  defp call(via, action) do
    pid =
      case GenServer.whereis(via) do
        nil ->
          {:ok, pid} = ItemSupervisor.start_item_server(via)
          pid
        pid ->
          pid
      end

    GenServer.call(pid, action)
  end
end

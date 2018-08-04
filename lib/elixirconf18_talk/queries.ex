defmodule Items.Queries do
  alias Items.Data

  def create(%Data{id: id} = item) do
    case :ets.insert_new(:items, {id, item}) do
      true -> item
      false -> :duplicate_item_error
    end
  end
  def create(_item), do: :invalid_item_struct

  def update(%Data{} = item) do
    true = :ets.insert(:items, {item.id, item})
    item
  end
  def update(_arg), do: :invalid_item_struct

  def fetch(id) do
    case :ets.lookup(:items, id) do
      [{_id, item}] -> item
      _             -> []
    end
  end
end
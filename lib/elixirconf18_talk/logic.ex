defmodule Items.Logic do
  alias Items.Data
  import Items.AllowedStates

  def set_location(%Data{} = item, location_id) when is_integer(location_id) do
    Map.put(item, :location_id, location_id)
  end

  def set_location(_item, location_id) when is_integer(location_id), do: :improper_item_struct
  def set_location(_item, _location_id), do: :non_integer_location_id

  def set_state(%Data{} = item, state) when in_allowed_states(state) do
    Map.put(item, :state, state)
  end

  def set_state(_item, state) when not in_allowed_states(state), do: :undefined_state
  def set_state(_item, _state), do: :improper_item_struct
end

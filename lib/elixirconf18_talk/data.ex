defmodule Items.Data do
  alias Items.Data
  import Items.AllowedStates

  @enforce_keys [:id, :state]
  defstruct [:id, :state, :location_id]

  def new(id, state, location_id \\ nil)
  def new(id, _state, _location_id) when not is_integer(id), do: :non_integer_id
  def new(_id, state, _location_id) when not in_allowed_states(state), do: :unknown_state
  def new(_id, _state, location_id) when not is_integer(location_id) and not is_nil(location_id), do: :non_integer_location_id
  def new(id, state, location_id), do: %Data{id: id, state: state, location_id: location_id}
end
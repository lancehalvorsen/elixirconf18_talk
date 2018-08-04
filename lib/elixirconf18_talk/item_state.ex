defmodule Items.ItemState do
  import Items.AllowedStates

  def transition_to_pullable(:locked), do: :error
  def transition_to_pullable(state) when in_allowed_states(state), do: :ok
  def transition_to_pullable(_state), do: :error
end
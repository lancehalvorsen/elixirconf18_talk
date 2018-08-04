defmodule Items.AllowedStates do
  defguard in_allowed_states(state) when state in [:cleaned, :locked, :pullable,  :pulled, :returned, :shipped]
end
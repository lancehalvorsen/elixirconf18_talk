defmodule Items.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.Items},
      {DynamicSupervisor, strategy: :one_for_one, name: Items.ItemSupervisor}
    ]

    :ets.new(:items, [:public, :named_table])
    opts = [strategy: :one_for_one, name: Items.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

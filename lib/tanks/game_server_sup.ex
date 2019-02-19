defmodule Tanks.GameServerSuper do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link __MODULE__, arg, name: __MODULE__
  end

  @impl true
  def init(_) do
    {:ok, _} = Registry.start_link(keys: :unique, name: Tanks.GameServerRegistry)
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(spec) do
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
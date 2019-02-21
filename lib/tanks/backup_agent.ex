defmodule Tanks.GameBackupAgent do
  use Agent

  def start_link(_) do
    Agent.start_link fn -> %{} end, name: __MODULE__
  end

  def put(key, value) do
    {:ok, Agent.update(__MODULE__, fn map -> Map.put(map, key, value) end)}
  end

  def get(key) do
    {:ok, Agent.get(__MODULE__, fn map -> Map.get(map, key) end)}
  end
end
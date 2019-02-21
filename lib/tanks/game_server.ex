defmodule Tanks.GameServer do
  use GenServer
  alias Tanks.Game
  alias Tanks.GameServerRegistry
  alias Tanks.GameServerSuper
  alias Tanks.GameBackupAgent

  # Internal API
  def reg(name) do
    {:via, Registry, {GameServerRegistry, name}}
  end

  def start_link(name) do
    game = GameBackupAgent.get(name) || Game.new(name)
    GenServer.start_link __MODULE__, game, name: reg(name)
  end

  # Static External API

  def get(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker,
    }
    case Registry.lookup(GameServerRegistry, name) do
      [{pid, _}] -> {:ok, pid}
      [] -> GameServerSuper.start_child(spec)
    end
  end

  def call(name, payload) do
    GenServer.call(reg(name), payload)
  end

  def cast(name, payload) do
    GenServer.call(reg(name), payload)
  end

  # Static External API - Game Interface

  def get_view(name, user), do: __MODULE__.call(name, {:get_view, %{user: user}})
  def join(name, user), do: __MODULE__.call(name, {:join, %{user: user}})
  def shoot(name, user), do: __MODULE__.call(name, {:shoot, %{user: user}})
  def move(name, user, direction), do: __MODULE__.call(name, {:move, %{
    user: user,
    direction: direction
  }})
  def turn(name, user, direction), do: __MODULE__.call(name, {:turn, %{
    user: user,
    direction: direction
  }})

  # Instance handlers

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:get_view, %{user: user}}, _from, game) do
    user_view_state = Game.get_user_view(game, user)
    {:reply, user_view_state, game}
  end

  @impl true
  def handle_call({:join, %{user: user}}, _from, game) do
    game = Game.join(game, user)
    user_view_state = Game.get_user_view(game, user)
    {:ok, _} = GameBackupAgent.put game.name, game
    {:reply, user_view_state, game}
  end

  @impl true
  def handle_call({:shoot, %{user: user}}, _from, game) do
    game = Game.shoot(game, user)
    user_view_state = Game.get_user_view(game, user)
    {:ok, _} = GameBackupAgent.put game.name, game
    {:reply, user_view_state, game}
  end

  @impl true
  def handle_call({:move, %{user: user, direction: direction}}, _from, game) do
    game = Game.move(game, user, direction)
    user_view_state = Game.get_user_view(game, user)
    {:ok, _} = GameBackupAgent.put game.name, game
    {:reply, user_view_state, game}
  end

  @impl true
  def handle_call({:turn, %{user: user, direction: direction}}, _from, game) do
    game = Game.turn(game, user, direction)
    user_view_state = Game.get_user_view(game, user)
    {:ok, _} = GameBackupAgent.put game.name, game
    {:reply, user_view_state, game}
  end
end
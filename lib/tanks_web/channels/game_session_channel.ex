defmodule TanksWeb.GameSessionChannel do
  use TanksWeb, :channel
  alias Tanks.GameServer

  def join("game_session:" <> name, _, socket) do
    user_name = socket.assigns.user_name
    if authorized?(name, user_name) do
      {:ok, _} = GameServer.get name
      GameServer.join(name, user_name)
      socket = assign(socket, :name, name)
      {:ok, GameServer.get_view(name, user_name), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("get_view", _, socket) do
    {:reply, GameServer.get_view(socket.assigns.name, socket.assigns.user_name), socket}
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    game_name = socket.assigns.name
    view = GameServer.move(game_name, socket.assigns.user_name, direction)
    TanksWeb.Endpoint.broadcast "game_session:" <> game_name, "view_update", view
    {:noreply, socket}
  end

  def handle_in("turn", %{"direction" => direction}, socket) do
    game_name = socket.assigns.name
    view = GameServer.turn(game_name, socket.assigns.user_name, direction)
    TanksWeb.Endpoint.broadcast "game_session:" <> game_name, "view_update", view
    {:noreply, socket}
  end

  def handle_in("shoot", _, socket) do
    game_name = socket.assigns.name
    user_name = socket.assigns.user_name
    view = GameServer.shoot(game_name, user_name)
    TanksWeb.Endpoint.broadcast "game_session:" <> game_name, "shot_fired", %{player: user_name}
    TanksWeb.Endpoint.broadcast "game_session:" <> game_name, "view_update", view
    {:noreply, socket}
  end

  def handle_in("reset", _, socket) do
    game_name = socket.assigns.name
    GameServer.reset(game_name)
    view = GameServer.join(game_name, socket.assigns.user_name)
    TanksWeb.Endpoint.broadcast "game_session:" <> game_name, "view_update", view
    {:noreply, socket}
  end

  def handle_in("join", _, socket) do
    game_name = socket.assigns.name
    view = GameServer.join(game_name, socket.assigns.user_name)
    TanksWeb.Endpoint.broadcast "game_session:" <> game_name, "view_update", view
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(game_name, user) do
    user !== "" && user !== nil && game_name !== "" && game_name !== nil
  end
end

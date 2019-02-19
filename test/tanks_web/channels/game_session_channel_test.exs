defmodule TanksWeb.GameSessionChannelTest do
  use TanksWeb.ChannelCase
  import Mock

  alias TanksWeb.GameSessionChannel

  setup do
    {:ok, _, socket} =
      socket("user_socket:bill", %{user_name: "bill"})
      |> subscribe_and_join(GameSessionChannel, "game_session:game")

    {:ok, socket: socket}
  end

  test "move broadcasts to game_session:game", %{socket: socket} do
    with_mock Tanks.GameServer,
        [move: fn (name, user, direction) ->
          %{view: "state:#{name}|#{user}|#{direction}"} end] do

      push socket, "move", %{"direction" => "left"}
      assert_broadcast "view_update", %{view: "state:game|bill|left"}
    end
  end

  test "shoot broadcasts to game_session:game", %{socket: socket} do
    with_mock Tanks.GameServer,
              [shoot: fn (name, user) ->
                %{view: "state:#{name}|#{user}"} end] do

      push socket, "shoot", %{}
      assert_broadcast "view_update", %{view: "state:game|bill"}
    end
  end

  test "turn broadcasts to game_session:game", %{socket: socket} do
    with_mock Tanks.GameServer,
              [turn: fn (name, user, direction) ->
                %{view: "state:#{name}|#{user}|#{direction}"} end] do

      push socket, "turn", %{"direction" => "left"}
      assert_broadcast "view_update", %{view: "state:game|bill|left"}
    end
  end

#  test "shout broadcasts to game_session:lobby", %{socket: socket} do
#    push socket, "shout", %{"hello" => "all"}
#    assert_broadcast "shout", %{"hello" => "all"}
#  end
#
#  test "broadcasts are pushed to the client", %{socket: socket} do
#    broadcast_from! socket, "broadcast", %{"some" => "data"}
#    assert_push "broadcast", %{"some" => "data"}
#  end
end

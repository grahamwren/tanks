defmodule Memory.GameTest do
  use ExUnit.Case
  alias Tanks.Game

  test "new game" do
    game = Game.new "helloGame"
    assert game == %Game{
      name: "helloGame",
      users: [],
      actions: []
    }
  end

  test "join game" do
    game = Game.new "game2"
    game = Game.join(game, "joe")
    %Game{
      name: "game2",
      users: [
        %{
          name: "joe",
          position: user_position
        }
      ]
    } = game
    assert user_position.x >= 0
    assert user_position.x <= 400
    assert user_position.y >= 0
    assert user_position.y <= 400
    assert user_position.shoot_angle >= 0
    assert user_position.shoot_angle <= 360
  end

  test "join game multi users" do
    game = Game.new "game2"
    game =
      game
      |> Game.join("joe")
      |> Game.join("bill")

    %Game{
      name: "game2",
      users: game_users
    } = game
    assert length(game_users) == 2
    assert Enum.map(game_users, fn %{name: name} -> name end) == ["bill", "joe"]
    Enum.each(game_users, fn %{position: user_position} ->
      assert user_position.x >= 0 &&
      assert user_position.x <= 400 &&
      assert user_position.y >= 0 &&
      assert user_position.y <= 400 &&
      assert user_position.shoot_angle >= 0 &&
      assert user_position.shoot_angle <= 360
    end)
  end

  test "move" do
    game = Game.new "game"
    game = Game.join(game, "alex")
    old_user_position = Enum.at(game.users, 0).position

    game = Game.move(game, "alex", "left")
    %Game{
      users: [
        %{
          name: "alex",
          position: user_position
        } | []
      ]
    } = game
    assert user_position.x < old_user_position.x
    assert user_position.y === old_user_position.y
    assert user_position.shoot_angle === old_user_position.shoot_angle
  end

  test "move offscreen" do
    game = Game.new "game"
    game = Game.join(game, "alex")
    game = %Game{
      game |
      users: [
        %{
          Enum.at(game.users, 0) |
          position: %{
            x: 2,
            y: 398,
            shoot_angle: 359
          }
        }
      ]
    }

    game =
      game
      |> Game.move("alex", "left")
      |> Game.move("alex", "up")

    %Game{
      users: [
        %{
          name: "alex",
          position: user_position
        } | []
      ]
    } = game
    assert user_position.x === 0
    assert user_position.y === 400
    assert user_position.shoot_angle === 359
  end

  test "turn" do
    game = Game.new "games"
    game = Game.join(game, "alex")
    old_user_position = Enum.at(game.users, 0).position

    game = Game.turn(game, "alex", "right")
    %Game{
      users: [
        %{
          name: "alex",
          position: user_position
        } | []
      ]
    } = game
    assert user_position.x === old_user_position.x
    assert user_position.y === old_user_position.y
    assert user_position.shoot_angle < old_user_position.shoot_angle
  end

  test "turn past 360 and 0" do
    game = Game.new "game"
    game = Game.join(game, "alex")
    game = %Game{
      game |
      users: [
        %{
          Enum.at(game.users, 0) |
          position: %{
            x: 2,
            y: 398,
            shoot_angle: 359
          }
        }
      ]
    }

    game = Game.turn(game, "alex", "left")

    %Game{
      users: [
        %{
          name: "alex",
          position: user_position
        } | []
      ]
    } = game
    assert user_position.x === 2
    assert user_position.y === 398
    assert user_position.shoot_angle === 1

    game = Game.turn(game, "alex", "right")

    %Game{
      users: [
        %{
          name: "alex",
          position: user_position
        } | []
      ]
    } = game
    assert user_position.x === 2
    assert user_position.y === 398
    assert user_position.shoot_angle === 359
  end
end
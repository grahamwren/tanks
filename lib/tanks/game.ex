defmodule Tanks.Game do
  @game_field_size 400
  @move_distance 5
  @turn_delta 2

  defstruct [
    name: "",
    users: [],
    actions: []
  ]

  alias Tanks.Game

  def new(name) do
    %Game{name: name}
  end

  def join(game, user_name) do
    if (Enum.find(game.users, fn user -> user.name === user_name end)) do
      game
    else
      %Game{
        game |
        users: [%{
          name: user_name,
          position: %{
            x: :rand.uniform(@game_field_size) - 1,
            y: :rand.uniform(@game_field_size) - 1,
            shoot_angle: :rand.uniform(360) - 1
          }
        } | game.users],
        actions: [[:join, user_name] | game.actions]
      }
    end
  end

  def shoot(game, user) do
    %Game{
      game |
      actions: [[:shoot, user] | game.actions]
    }
  end

  def move(game, user, direction) do
    %Game{
      game |
      users: move_user(game.users, user, direction),
      actions: [[:move, user, direction] | game.actions]
    }
  end

  def turn(game, user, direction) do
    %Game{
      game |
      users: turn_user(game.users, user, direction),
      actions: [[:turn, user, direction] | game.actions]
    }
  end

  def get_user_view(game, _user) do
    %{
      positions: game.users,
      actions: game.actions,
      name: game.name
    }
  end

  def move_user([], _un, _d), do: []
  def move_user([%{name: this_name} = user | rest], user_name, direction)
      when this_name == user_name do
    {x, y} = case direction do
      "left" -> {user.position.x - @move_distance, user.position.y}
      "right" -> {user.position.x + @move_distance, user.position.y}
      "up" -> {user.position.x, user.position.y + @move_distance}
      "down" -> {user.position.x, user.position.y - @move_distance}
    end
    [%{
      user |
      position: %{
        user.position |
        x: x,
        y: y
      }
    } | rest]
  end
  def move_user([user | rest], un, d),
      do: [user | move_user(rest, un, d)]

  def turn_user([], _un, _d), do: []
  def turn_user([%{name: this_name} = user | rest], user_name, direction)
      when this_name == user_name do
    angle = case direction do
      "left" -> user.position.shoot_angle + @turn_delta
      "right" -> user.position.shoot_angle - @turn_delta
    end
    [%{
      user |
      position: %{
        user.position |
        shoot_angle: angle
      }
    } | rest]
  end
  def turn_user([user | rest], un, d), do: [user | turn_user(rest, un, d)]
end
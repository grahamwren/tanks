defmodule Tanks.Game do
  alias Tanks.Utils

  @game_field_size 400
  @move_distance 5
  @turn_delta 2
  @shot_damage 30
  @shot_accuracy 10

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
          health: 100,
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
    if is_dead(game.users, user) do
      game
    else
      case get_closest_hit(game.users, user) do
        {:hit, hit_user} -> %Game{
          game |
          users: damage_user(game.users, hit_user)
        }
        :no_hit -> game
      end
    end
  end

  def move(game, user, direction) do
    if is_dead(game.users, user) do
      game
    else
      %Game{
        game |
        users: move_user(game.users, user, direction),
        actions: [[:move, user, direction] | game.actions]
      }
    end
  end

  def turn(game, user, direction) do
    if is_dead(game.users, user) do
      game
    else
      %Game{
        game |
        users: turn_user(game.users, user, direction),
        actions: [[:turn, user, direction] | game.actions]
      }
    end
  end

  def get_user_view(game, _user) do
    %{
      positions: game.users,
      actions: game.actions,
      name: game.name
    }
  end

  def move_user(user_list, user, direction),
      do: Utils.get_user_transformer(fn user, direction ->
        {x, y} = case direction do
          "left" -> {user.position.x - @move_distance, user.position.y}
          "right" -> {user.position.x + @move_distance, user.position.y}
          "up" -> {user.position.x, user.position.y + @move_distance}
          "down" -> {user.position.x, user.position.y - @move_distance}
        end
        %{
          user |
          position: normalize_position(%{
            user.position |
            x: x,
            y: y
          })
        }
      end).(user_list, user, direction)

  def turn_user(user_list, user, direction),
    do: Utils.get_user_transformer(fn user, direction ->
      angle = case direction do
        "left" -> user.position.shoot_angle + @turn_delta
        "right" -> user.position.shoot_angle - @turn_delta
      end
      %{
        user |
        position: normalize_position(%{
          user.position |
          shoot_angle: angle
        })
      }
    end).(user_list, user, direction)

  def damage_user(user_list, user),
    do: Utils.get_user_transformer(fn user, _ ->
      if user.health < @shot_damage,
        do: %{
          user |
          health: 0
        },
        else: %{
          user |
          health: user.health - @shot_damage
        }
    end).(user_list, user, nil)

  def normalize_position(position) do
    x = if (position.x > @game_field_size), do: @game_field_size, else: position.x
    x = if (x < 0), do: 0, else: x

    y = if (position.y > @game_field_size), do: @game_field_size, else: position.y
    y = if (y < 0), do: 0, else: y

    angle = rem position.shoot_angle, 360
    angle = if (angle < 0), do: 360 + angle, else: angle

    %{
      x: x,
      y: y,
      shoot_angle: angle
    }
  end

  def get_closest_hit(users, shooter_name) do
    hits = get_all_hits(users, shooter_name) # List<%Hit{user: <user_name>, distance: <distance>}>
    case Enum.sort_by(hits, fn hit -> hit.distance end) do
      [] -> :no_hit
      [%{user: user} | _] -> {:hit, user}
    end
  end

  # -> List<%Hit{user: <user_name>, distance: <distance>}>
  def get_all_hits(users, shooter_name) do
    shooter = Enum.find(users, fn %{name: name} -> name === shooter_name end)
    targets = Enum.filter(users, fn %{name: name} -> name !== shooter_name end)
    if (shooter === nil || targets === []) do
      []
    else
      hit_users = Enum.filter(targets, fn %{position: t_position} ->
        is_hit(shooter.position, t_position)
      end)
      Enum.map(hit_users, fn hit_target ->
        %{
          user: hit_target.name,
          distance: Utils.distance(hit_target.position, shooter.position)
        }
      end)
    end
  end

  def is_hit(shooter_position, target_position) do
    # need this to ensure correct direction because lines go both directions
    dir_validator = case shooter_position.shoot_angle do
      a when a <= 90 ->
        fn %{x: x, y: y} -> x >= shooter_position.x && y >= shooter_position.y end
      a when a <= 180 ->
        fn %{x: x, y: y} -> x < shooter_position.x && y >= shooter_position.y end
      a when a <= 270 ->
        fn %{x: x, y: y} -> x <= shooter_position.x && y < shooter_position.y end
      a when a <= 360 ->
        fn %{x: x, y: y} -> x > shooter_position.x && y <= shooter_position.y end
    end

    s_a_rad = (shooter_position.shoot_angle / 180) * :math.pi
    # looking for bY + aX + c = 0

    a = :math.tan(s_a_rad)
    # Y + sp.y = a(X + sp.x)

    # Y + sp.y = aX + (a * sp.x)
    c = shooter_position.y - (shooter_position.x * a)
    # (1)Y + c = aX
    # (1)Y + (-a)X + c = 0
    # dist = |a(tp.x) + b(tp.y) + c| / sqrt(a^2 + b^2) when line = aX + bY + c = 0
    dist = abs(((-1 * a) * target_position.x) + target_position.y - c) / :math.sqrt(:math.pow(a, 2) + 1)
    dist < @shot_accuracy && dir_validator.(target_position)
  end

  def is_dead(users_list, user_name),
      do: Enum.any? users_list, fn %{name: name, health: health} ->
        name === user_name && health <= 0
      end
end
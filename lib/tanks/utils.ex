defmodule Tanks.Utils do
  # generic user updater using the Y combinator
  # return nil to delete
  def get_user_transformer(transformer) do
    applier = fn rec ->
      fn
        ([], _user_name, _opts) -> []

        ([%{name: name} = user | rest], user_name, opts) when name === user_name ->
          new_user = transformer.(user, opts)
          if new_user === nil, do: rest, else: [new_user | rest]

        ([user | rest], user_name, opts) -> [user | rec.(rec).(rest, user_name, opts)]
      end
    end
    applier.(applier) # Y
  end

  def distance(p1, p2),
      do: :math.sqrt(:math.pow(p1.x - p2.x, 2) + :math.pow(p1.y - p2.y, 2))
end
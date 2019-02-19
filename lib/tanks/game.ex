defmodule Tanks.Game do
   defstruct name: "", actions: []
   alias Tanks.Game

   def new(name) do
     %Game{name: name}
   end

   def join(game, user) do
     %Game{
       game |
       actions: [{:join, user} | game.actions]
     }
   end

   def shoot(game, user) do
     %Game{
       game |
       actions: [{:shoot, user} | game.actions]
     }
   end

   def move(game, user, direction) do
     %Game{
       game |
       actions: [{:move, user, direction} | game.actions]
     }
   end

   def turn(game, user, direction) do
     %Game{
       game |
       actions: [{:turn, user, direction} | game.actions]
     }
   end

   def get_user_view(game, user) do
     %{target: user, game: game}
   end
end
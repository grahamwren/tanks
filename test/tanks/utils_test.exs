defmodule Tanks.UtilsTest do
  use ExUnit.Case
  alias Tanks.Utils


  @user_list [
    %{
      name: "alice",
      password: "bad_pass"
    },
    %{
      name: "alex",
      password: "bad_pass2"
    },
    %{
      name: "bill",
      password: "bad_pass3"
    }
  ]

  test "get_user_transformer" do
    update_pass = fn user, v ->
      %{
        user |
        password: v
      }
    end
    transformer = Utils.get_user_transformer(update_pass)
    assert Enum.at(transformer.(@user_list, "alex", "new_pass"), 1) == %{
      name: "alex",
      password: "new_pass"
    }
  end
end
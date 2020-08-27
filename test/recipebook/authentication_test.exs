defmodule Recipebook.AuthenticationTest do
  use Recipebook.DataCase, async: true
  alias Recipebook.Support.UserSupport
  alias Recipebook.Authentication

  def setup_user_raw_data(context) do
    {:ok, user} = UserSupport.generate_user_raw_data
    Map.put(context, :user, user)
  end
  describe "&login_user/1" do
    setup [:setup_user_raw_data]
    test "correct password and return token" , context do
      user = context[:user]
      assert {:ok, data} = Authentication.login_user(%{username: user.username, password: user.password})
      assert data.token
      {:ok, decoded_token} = Authentication.decode_and_verify(data.token)
      assert to_string(decoded_token["sub"]) === to_string(user.id)
    end
    test "wrong password and return error" , context do
      user = context[:user]
      assert {:error, _} = Authentication.login_user(%{username: user.username, password: "12345"})
    end
  end

end

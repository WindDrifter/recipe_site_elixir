defmodule Recipebook.Authentication do
  use Guardian, otp_app: :recipebook
  alias Recipebook.Account
  import Argon2

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    Account.find_user(%{id: id})
  end

  def login_user(params \\ %{}) do
    with {:ok, user} <- verify_user(params),
         {:ok, jwt, _} <- encode_and_sign(user) do
      {:ok, %{token: jwt}}
    else
      {:error, _reason} ->
        {:error, "Wrong password or invalid username"}
    end
  end
  def verify_user(%{password: input_password, username: input_username} = _params) do
    case Account.find_user(%{username: input_username}) do
      {:ok, user} -> check_pass(user, input_password, hash_key: :password)
      {:error, reason} -> {:error, reason}
    end
  end

 end

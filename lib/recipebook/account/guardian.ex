defmodule Recipebook.Account.Guardian do
  use Guardian, otp_app: :recipebook

  alias Recipebook.Account

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resources_from_claims(%{"sub" => id}) do
    Account.get_user(%{id: id})
  end

end

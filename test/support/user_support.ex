defmodule Recipebook.Support.UserSupport do
  alias Recipebook.Account
  def generate_users do
    for n <- 1..10 do
      Account.create_user(%{
        name: "test user #{n}",
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      })
    end
  end

  def generate_users_with_random_name do
    for _n <- 1..10 do
      Account.create_user(%{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      })
    end
  end

  # raw means raw data. Ie: non hashed password
  def generate_user(raw \\ false) do
    params = %{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: Faker.String.base64()
    }
    {_, user} = Account.create_user(params)
    if raw do
      params = Map.put(params, :id, user.id)
      {:ok, params}
    else
      {:ok, user}
    end
  end
  def create_unsaved_user do
    {:ok, %{
      "name" => Faker.Person.name(),
      "email" => Faker.Internet.email(),
      "username" => Faker.Internet.user_name(),
      "password" => Faker.String.base64()
    }}

  end
end

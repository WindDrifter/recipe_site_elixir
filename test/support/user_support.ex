defmodule Recipebook.Support.UserSupport do
  alias Recipebook.Account
  def generate_users do
    for n <- 1..3 do
      Account.create_user(%{
        name: "test user #{n}",
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: "123456"
      })
    end
  end
  def generate_user do
    Account.create_user(%{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: "123456"
    })
  end
  def create_unsaved_user do
    {:ok, %{
      "name" => Faker.Person.name(),
      "email" => Faker.Internet.email(),
      "username" => Faker.Internet.user_name(),
      "password" => "123456"
    }}

  end
end

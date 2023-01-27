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

  def generate_users_and_following_chef(max \\ 10) do
    {:ok, follower} =
      Account.create_user(%{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      })

    for _n <- 1..max do
      {:ok, chef} =
        Account.create_user(%{
          name: Faker.Person.name(),
          email: Faker.Internet.email(),
          username: Faker.Internet.user_name(),
          password: Faker.String.base64()
        })

      Account.follow_user(follower, %{id: chef.id})
    end

    {:ok, follower}
  end

  def create_an_chef_and_follow(user) do
    {:ok, chef} =
      Account.create_user(%{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      })

    Account.follow_user(user, %{id: chef.id})
    {:ok, chef}
  end

  def generate_users_and_followers(max \\ 10) do
    {:ok, user} =
      Account.create_user(%{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      })

    for _n <- 1..max do
      {:ok, follower} =
        Account.create_user(%{
          name: Faker.Person.name(),
          email: Faker.Internet.email(),
          username: Faker.Internet.user_name(),
          password: Faker.String.base64()
        })

      Account.follow_user(follower, %{id: user.id})
    end

    {:ok, user}
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
  def generate_user do
    params = %{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: Faker.String.base64()
    }

    Account.create_user(params)
  end

  def generate_user_raw_data do
    params = %{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: Faker.String.base64()
    }

    {:ok, user} = Account.create_user(params)
    params = Map.put(params, :id, user.id)
    {:ok, params}
  end

  def create_unsaved_user do
    {:ok,
     %{
       "name" => Faker.Person.name(),
       "email" => Faker.Internet.email(),
       "username" => Faker.Internet.user_name(),
       "password" => Faker.String.base64()
     }}
  end
end

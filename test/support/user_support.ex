defmodule Recipebook.Support.UserSupport do
  alias Recipebook.Account
  def generate_users do
    for n <- 1..3 do
      Account.create_user(%{
        name: "test user #{n}",
        email: Faker.Internet.email(),
        preference: %{
          likes_emails: true,
          likes_phone_calls: true
        }
      })
    end
    for n <- 4..6 do
      Account.create_user(%{
        name: "test user #{n}",
        email: Faker.Internet.email(),
        preference: %{
          likes_emails: false,
          likes_phone_calls: false
        }
      })
    end
  end
  def generate_user do
    Account.create_user(%{
      name: "random user",
      email: Faker.Internet.email(),
      preference: %{
        likes_emails: true,
        likes_phone_calls: false
      }
    })
  end
end

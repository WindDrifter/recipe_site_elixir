defmodule Recipebook.Account do
  alias Recipebook.Account.User
  alias Recipebook.Cookbook.Recipe
  alias Recipebook.Authentication
  alias EctoShorts.Actions
  @user_query User.setup_query()
  @cannot_find_user_tuple {:error, "Cannot find user"}

  def all_users(params \\ %{}) do
    {search, params} = Map.split(params, [:name, :username])
    query = Enum.reduce(search, @user_query, &convert_field_to_query/2)
    {:ok, Actions.all(query, params)}
  end

  def get_followers(params) do
    case find_user(add_preload_in_params(params, [:followers])) do
      {:ok, user} -> {:ok, user.followers}
      {:error, _} -> {:error, "Cannot find user"}
    end
  end

  def get_following(params) do
    case find_user(add_preload_in_params(params, [:following])) do
      {:ok, user} ->  {:ok, user.following}
      {:error, _} -> @cannot_find_user_tuple
    end
  end
  def follow_user(user, %{id: id} = _params) do
    with {:ok, following_user} <- find_user(%{id: id}),
      {:ok, _user} <- Actions.update(User, user, following: [%{id: following_user.id} | turn_following_list_into_list_of_ids(user)])
    do
      {:ok, %{message: "Successfully followed user", followed_user: user.name}}
    else
      {:error, message} -> {:error, message}
    end
  end

  def unfollow_user(user, %{id: id} = _params) do
    case Actions.update(User, user, following: turn_following_list_into_list_of_ids(user, id)) do
      {:ok, _} -> {:ok, %{message: "Successfully unfollow user"}}
      {:error, message} -> {:error, message}
    end
  end

  defp turn_following_list_into_list_of_ids(user, reject_id \\ -1) do
    case  get_following(%{id: user.id}) do
      {:ok, followings} -> entries_into_list_of_ids(followings, reject_id)
      {:error, message} -> {:error, message}
    end
  end

  defp entries_into_list_of_ids(entries, reject_id) do
    Enum.flat_map(entries,
    fn entry ->
      case to_string(entry.id) === to_string(reject_id) do
        false -> [%{id: entry.id}]
        true -> []
      end
    end
    )
  end


  defp convert_field_to_query({:name, value}, query) do
    User.by_name(query, value)
  end

  defp convert_field_to_query({:username, value}, query) do
    User.by_username(query, value)
  end

  def find_user(params \\ %{}) do
    Actions.find(@user_query, params)
  end

  def update_user(user, id, %{current_password: current_password} = params) do
    case Authentication.verify_user(%{username: user.username, password: current_password}) do
      {:ok, _user} -> if user.id === id do Actions.update(User, id, params) else {:error, "You do not have permission to change user details"} end
      {:error, reason} -> {:error, reason.message}
    end
  end

  def create_user(params) do
    Actions.create(User, params)
  end


  def get_saved_recipes(user) do
    case find_user(add_preload_in_params(%{id: user.id}, [:saved_recipes])) do
      {:ok, user} ->  {:ok, user.saved_recipes}
      {:error, _} -> @cannot_find_user_tuple
    end
  end

  def save_recipe(user, %{recipe_id: recipe_id} = _params) do
    with {:ok, recipe} <- Actions.find(Recipe.setup_query(), %{id: recipe_id}),
      {:ok, _user} <- Actions.update(User, user, saved_recipes: [%{id: recipe.id} | get_list_of_save_recipe_ids(user)])
    do
      {:ok, %{message: "Successfully saved recipe", name: recipe.name}}
    else
      {:error, errors} -> {:error, errors.message}
    end
  end

  def unsave_recipe(user, %{recipe_id: recipe_id} = _params) do
    case Actions.update(User, user, saved_recipes: get_list_of_save_recipe_ids(user, recipe_id)) do
      {:ok, user} -> {:ok, %{message: "Successfully unsave recipe"}}
      {:error, message} -> {:error, message}
    end
  end

  defp get_list_of_save_recipe_ids(user, reject_id \\ -1) do
    case get_saved_recipes(user) do
      {:ok, saved_recipes} -> entries_into_list_of_ids(saved_recipes, reject_id)
      {:error, message} -> {:error, message}
    end
  end


  defp add_preload_in_params(params, keys) do
    Map.put(params, :preload, keys)
  end

end

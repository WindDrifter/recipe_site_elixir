defmodule Recipebook.RecipeCounter do
  use Agent
  @default_name Recipebook.RecipeCounter

  def start_link(opts \\ []) do
    initial_state = %{}
    opts = Keyword.put_new(opts, :name, @default_name)
    Agent.start_link(fn -> initial_state end, opts)
  end

  def child_spec([]) do
    %{
      id: Recipebook.RecipeCounter,
      start: {Recipebook.RecipeCounter, :start_link, []}
    }
  end

  def child_spec(opts) when opts !== [] do
    %{
      id: opts[:name],
      start: {Recipebook.RecipeCounter, :start_link, [opts]}
    }
  end

  def increment_by_one(name \\ @default_name, key) do
    Agent.update(name, fn state -> Recipebook.RecipeViewStatisticsImpl.add_one_view(state, key) end)
  end

  def get_current_state_by_key(name \\ @default_name, key) do
    Agent.get(name, fn state -> {:ok,  Map.get(state, key, 0)} end)
  end

  def get_top(name \\ @default_name, amount) do
    Agent.get(name, fn state -> {:ok, Recipebook.RecipeViewStatisticsImpl.get_top_n_with_most_views(state, amount)} end)
  end

  def get_current_state(name \\ @default_name) do
    Agent.get(name, fn state -> {:ok, state} end)
  end

  def erase_state(name \\ @default_name) do
    Agent.update(name, fn _state -> %{} end)
  end

end

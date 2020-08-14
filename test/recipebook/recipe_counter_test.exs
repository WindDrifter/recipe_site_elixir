defmodule RecipeCounterTest do
  use ExUnit.Case, async: true
  alias Recipebook.RecipeCounter
  setup do
    {:ok, pid} = RecipeCounter.start_link(name: nil)
    %{pid: pid}
  end

  describe  "&get_current_state_by_key/2" do
    test "assert it return as a tuple", %{pid: pid} do
      assert is_tuple(RecipeCounter.get_current_state_by_key(pid, "Chinese"))
     end
    test "returns 0 as default non existance key", %{pid: pid} do
     {_, state} = RecipeCounter.get_current_state_by_key(pid, "Chinese")
     assert state === 0
    end
  end
  # describe  "&get_current_state/1" do
  #   test "assert it return as a tuple", %{pid: pid} do
  #     assert is_tuple(RecipeCounter.get_current_state(pid))
  #    end
  #   test "assert state return as map", %{pid: pid} do
  #    {_, state} = RecipeCounter.get_current_state(pid)
  #    assert is_map(state)
  #   end
  # end
  describe  "&increment_by_one/2" do
    test "assert only the related key added by 1" , %{pid: pid} do
      RecipeCounter.increment_by_one(pid, "Chinese")
      {_, state} = RecipeCounter.get_current_state_by_key(pid, "Chinese")
      assert state === 1
      {_, state} = RecipeCounter.get_current_state_by_key(pid, "Japanese")
      assert state === 0
    end
  end
  # describe  "&erase_state/1" do
  #   test "assert state reset" do
  #     ResolverCounter.increment_by_one("add_user")
  #     ResolverCounter.erase_state()
  #     assert {_, state} = ResolverCounter.get_current_state()
  #     assert state === %{}
  #     assert {_, count} = ResolverCounter.get_current_count_by_key("add_user")
  #     assert count === 0
  #   end
  # end
end

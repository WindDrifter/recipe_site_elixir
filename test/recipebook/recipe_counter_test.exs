defmodule RecipeViewCounterTest do
  use ExUnit.Case, async: true
  alias Recipebook.RecipeViewCounter
  setup do
    {:ok, pid} = RecipeViewCounter.start_link(name: nil)
    %{pid: pid}
  end

  describe  "&get_current_state_by_key/2" do
    test "assert it return as a tuple", %{pid: pid} do
      assert is_tuple(RecipeViewCounter.get_current_state_by_key(pid, "Chinese"))
     end
    test "returns 0 as default non existance key", %{pid: pid} do
     {:ok, state} = RecipeViewCounter.get_current_state_by_key(pid, "Chinese")
     assert state === 0
    end
  end

  describe  "&increment_by_one/2" do
    test "assert only the related key added by 1" , %{pid: pid} do
      RecipeViewCounter.increment_by_one(pid, "Chinese")
      {:ok, state} = RecipeViewCounter.get_current_state_by_key(pid, "Chinese")
      assert state === 1
      {:ok, state} = RecipeViewCounter.get_current_state_by_key(pid, "Japanese")
      assert state === 0
    end
  end

end

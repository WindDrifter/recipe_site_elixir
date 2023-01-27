defmodule RecipebookWeb.Middleware.HandleError do
  @behaviour Absinthe.Middleware
  def call(resolution, _) when resolution.errors != [] do

    errors =
      Enum.flat_map(resolution.errors, &handle_error/1)
      |> Map.new()
      |> then(&{:error, &1})

    Absinthe.Resolution.put_result(resolution, errors)
  end

  def call(resolution, _) when resolution.errors === [] do
    resolution
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do

    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
    |> Enum.map(fn {k, v} -> {:message, "#{k}: #{v}"} end)
    |> Keyword.put(:code, :bad_request)
  end

  defp handle_error(%ErrorMessage{} = result) do

    result
    |> Map.from_struct()
    |> Map.delete(:details)
  end

  defp handle_error(errors) do
    errors
  end
end

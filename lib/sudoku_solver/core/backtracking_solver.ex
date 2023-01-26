defmodule SudokuSolver.Core.BacktrackingSolver do
  @moduledoc """
  It solves the board using backtracking algorithm.
  """

  alias SudokuSolver.Core.Board

  @type coordinates :: Board.coordinates()

  @spec solve(list) :: {:ok, list} | {:full, list} | {:invalid, list}
  def solve(board) do
    with true <- Board.board_correct?(board),
         {:not_full, _} <- Board.check_if_full(board) do
      {:ok, find_solution({board, 0, %{}})}
    else
      {:full, _} -> {:ok, board}
      _ -> {:invalid, board}
    end
  end

  @spec find_solution({list, non_neg_integer(), map}) :: list
  defp find_solution({board, depth, checked_values}) do
    with {:ok, {coordinates, value}} <- next_to_check(board, depth, checked_values),
         {:ok, possible_for_cell} <- Board.possible_for_cell(board, coordinates),
         {:ok, value} <- check_value(value, possible_for_cell),
         updated_board = Board.update(board, coordinates, value),
         updated_checked = update_checked_values(value, depth, checked_values),
         {:not_full, _board} <- Board.check_if_full(updated_board) do
      find_solution({updated_board, depth + 1, updated_checked})
    else
      {:error, :no_next_value} ->
        find_solution(choose_next_step(board, depth, checked_values))

      {:error, :no_values} ->
        find_solution(go_back(board, depth, checked_values))

      {:invalid_value, value} ->
        updated_checked = update_checked_values(value, depth, checked_values)

        find_solution(choose_next_step(board, depth, updated_checked))

      {:full, board} ->
        board
    end
  end

  @spec get_allowed_values(list) :: list
  defp get_allowed_values(board) do
    case GenServer.whereis(__MODULE__) do
      nil -> prepare_allowed_values(board)
      _ -> Agent.get(__MODULE__, fn map -> Map.get(map, :allowed_values) end)
    end
  end

  @spec prepare_allowed_values(list) :: list
  defp prepare_allowed_values(board) do
    values = Board.all_allowed_values(board)
    Agent.start_link(fn -> %{:allowed_values => values} end, name: __MODULE__)
    values
  end

  @spec check_value(non_neg_integer(), list(non_neg_integer())) ::
          {:error, :invalid_value} | {:ok, non_neg_integer()}
  defp check_value(value, possible_list) do
    case Enum.member?(possible_list, value) do
      true -> {:ok, value}
      _ -> {:invalid_value, value}
    end
  end

  @spec go_back(list, non_neg_integer(), map) :: {list, non_neg_integer(), map}
  defp go_back(board, depth, checked_values) do
    updated_checked = Map.update(checked_values, depth, [], fn _ -> [] end)
    {coordinates, _val} = Enum.at(get_allowed_values(board), depth, [])
    board = Board.update(board, coordinates, 0)
    {board, depth - 1, updated_checked}
  end

  @spec next_to_check(list, non_neg_integer(), map) ::
          {:error, :no_next} | {:ok, {coordinates, non_neg_integer()}}
  defp next_to_check(board, depth, checked_values) do
    {cell_coordinates, allowed_depth_values} = Enum.at(get_allowed_values(board), depth, [])
    checked_depth_values = Map.get(checked_values, depth, [])

    value_to_check =
      Enum.find(allowed_depth_values, fn x -> !Enum.member?(checked_depth_values, x) end)

    case value_to_check do
      nil -> {:error, :no_next_value}
      _ -> {:ok, {cell_coordinates, value_to_check}}
    end
  end

  @spec update_checked_values(non_neg_integer(), non_neg_integer(), map) :: map
  defp update_checked_values(value, depth, checked_values) do
    already_checked_values = Map.get(checked_values, depth, [])
    updated_checked_values = [value | already_checked_values]
    Map.put(checked_values, depth, updated_checked_values)
  end

  @spec choose_next_step(list, non_neg_integer(), map) :: {list, non_neg_integer(), map}
  defp choose_next_step(board, depth, checked_values) do
    checked_depth_values = Map.get(checked_values, depth, [])
    {coordinates, allowed_depth_values} = Enum.at(get_allowed_values(board), depth, [])

    case all_values_checked?(allowed_depth_values, checked_depth_values) do
      true ->
        board = Board.update(board, coordinates, 0)
        updated_checked = Map.update(checked_values, depth, [], fn _ -> [] end)
        choose_next_step(board, depth - 1, updated_checked)

      _ ->
        {board, depth, checked_values}
    end
  end

  @spec all_values_checked?(list, list) :: true | false
  defp all_values_checked?(possible_values, checked_values) do
    length(possible_values) == length(checked_values)
  end
end

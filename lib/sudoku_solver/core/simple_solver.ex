defmodule SudokuSolver.Core.SimpleSolver do
  @moduledoc """
  It tries to solve the board going through each
  cell and filling it with one of the possible values.
  """

  alias SudokuSolver.Core.Board

  @spec solve(list) :: list
  def solve(board) do
    with true <- Board.board_correct?(board),
         {:not_full, _} <- Board.check_if_full(board) do
      solve(board, 0, board)
    else
      _ -> board
    end
  end

  @spec solve(list, non_neg_integer(), list) :: list
  defp solve(board, i, initial_board) do
    if i < 81 do
      row = rem(i, 9)
      col = div(i, 9)

      with true <- Board.board_at(board, {col, row}) == 0,
           {:ok, value} <- Board.next_possible_value(board, {col, row}),
           updated_board <- Board.update(board, {col, row}, value),
           {:not_full, _board} <- Board.check_if_full(updated_board) do
        solve(updated_board, i + 1, initial_board)
      else
        {:error, nil} ->
          solve(initial_board)

        {:full, board} ->
          board

        _ ->
          solve(board, i + 1, initial_board)
      end
    end
  end
end

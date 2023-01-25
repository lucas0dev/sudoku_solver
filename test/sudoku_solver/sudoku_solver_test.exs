defmodule SudokuSolverTest do
  use ExUnit.Case
  alias BoardHelper, as: Helper

  setup_all do
    full_board = Helper.full_board()
    board = Helper.board()
    unsolvable_board = Helper.unsolvable_board()
    empty_board = Helper.empty_board()

    {:ok,
     full_board: full_board,
     board: board,
     unsolvable_board: unsolvable_board,
     empty_board: empty_board}
  end

  describe "run(board) with solvable board" do
    test "should solve board and return {:ok, board}", %{board: board} do
      {:ok, board} = SudokuSolver.run(board)
      cells = List.flatten(board)
      result = Enum.all?(cells, fn cell -> cell > 0 end)

      assert result == true
    end
  end

  describe "run(board) with empty board" do
    test "should solve board and return {:ok, board} ", %{empty_board: empty_board} do
      {:ok, board} = SudokuSolver.run(empty_board)
      cells = List.flatten(board)
      result = Enum.all?(cells, fn cell -> cell > 0 end)

      assert result == true
    end
  end

  describe "run(board) with unsolvable board" do
    test "should partially solve board and return {:invalid, board}", %{
      unsolvable_board: unsolvable_board
    } do
      {:invalid, board} = SudokuSolver.run(unsolvable_board)
      cells = List.flatten(board)
      result = Enum.all?(cells, fn cell -> cell > 0 end)

      assert board != unsolvable_board
      assert result != true
    end
  end
end

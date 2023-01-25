defmodule SudokuSolver.Core.BacktrackingSolverTest do
  use ExUnit.Case

  alias BoardHelper, as: Helper
  alias SudokuSolver.Core.BacktrackingSolver, as: Solver

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

  describe "solve(board) when board is empty" do
    test "should solve board and return {:ok, board}", %{empty_board: empty_board} do
      {:ok, solved_board} = Solver.solve(empty_board)
      solved_board = List.flatten(solved_board)
      result = Enum.all?(solved_board, fn cell -> cell > 0 end)

      assert result == true
    end
  end

  describe "solve(board) when board is solved" do
    test "should not modify board and return {:full, board}", %{full_board: full_board} do
      {:ok, board} = Solver.solve(full_board)

      assert board == full_board
    end
  end

  describe "solve(board) when board is solvable" do
    test "should solve board and return {:ok, board}", %{board: board} do
      {:ok, solved_board} = Solver.solve(board)
      solved_board = List.flatten(solved_board)
      result = Enum.all?(solved_board, fn cell -> cell > 0 end)
      assert result == true
    end
  end

  describe "solve(board) when board is unsolvable" do
    test "should not modify board and return {:invalid, board}", %{
      unsolvable_board: unsolvable_board
    } do
      {:invalid, board} = Solver.solve(unsolvable_board)

      assert board == unsolvable_board
    end
  end
end

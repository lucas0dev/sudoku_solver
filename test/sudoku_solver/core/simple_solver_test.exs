defmodule SudokuSolver.Core.SimpleSolverTest do
  use ExUnit.Case

  alias BoardHelper, as: Helper
  alias SudokuSolver.Core.SimpleSolver, as: Solver

  setup_all do
    full_board = Helper.full_board()
    board = Helper.board()
    empty_board = Helper.empty_board()
    unsolvable_board = Helper.unsolvable_board()

    {:ok,
     full_board: full_board,
     board: board,
     unsolvable_board: unsolvable_board,
     empty_board: empty_board}
  end

  describe "solve(board) when board is already solved" do
    test "should not modify board and return {:full, board}", %{full_board: full_board} do
      {:ok, board} = Solver.solve(full_board)

      assert board == full_board
    end
  end

  describe "solve(board) when board can be solved" do
    test "should solve board and return {:ok, board}", %{board: board} do
      {:ok, board} = Solver.solve(board)

      is_board_solved =
        board
        |> List.flatten()
        |> Enum.all?(fn x -> x > 0 end)

      assert is_board_solved == true
    end
  end

  describe "solve(board) when board is empty" do
    test "should solve board and return {:ok, board}", %{empty_board: empty_board} do
      {:ok, board} = Solver.solve(empty_board)

      is_board_solved =
        board
        |> List.flatten()
        |> Enum.all?(fn x -> x > 0 end)

      assert is_board_solved == true
    end
  end

  describe "solve(board) when board can't be solved" do
    test "should not modify board and return {:invalid, board}", %{
      unsolvable_board: unsolvable_board
    } do
      {:invalid, board} = Solver.solve(unsolvable_board)

      assert board == unsolvable_board
    end
  end
end

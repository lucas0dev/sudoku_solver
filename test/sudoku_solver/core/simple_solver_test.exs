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
    test "should return unchanged board", %{full_board: full_board} do
      board_after = Solver.solve(full_board)

      assert board_after == full_board
    end
  end

  describe "solve(board) when board can be solved" do
    test "should return solved board", %{board: board} do
      is_board_solved =
        Solver.solve(board)
        |> List.flatten()
        |> Enum.all?(fn x -> x > 0 end)

      assert is_board_solved == true
    end
  end

  describe "solve(board) when board is empty" do
    test "should return solved board", %{empty_board: empty_board} do
      is_board_solved =
        Solver.solve(empty_board)
        |> List.flatten()
        |> Enum.all?(fn x -> x > 0 end)

      assert is_board_solved == true
    end
  end

  describe "solve(board) when board can't be solved" do
    test "should return unchanged board", %{unsolvable_board: unsolvable_board} do
      board_after = Solver.solve(unsolvable_board)

      assert board_after == unsolvable_board
    end
  end
end

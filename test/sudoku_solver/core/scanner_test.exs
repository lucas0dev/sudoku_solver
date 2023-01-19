defmodule SudokuSolver.Core.ScannerTest do
  use ExUnit.Case

  alias BoardHelper, as: Helper
  alias SudokuSolver.Core.Scanner, as: Scanner

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

  describe "run(board) when board is empty" do
    test "should return unchanged board", %{empty_board: empty_board} do
      assert Scanner.run(empty_board) == empty_board
    end
  end

  describe "run(board) when board can be solved" do
    test "should update a cell with a value that does not fit anywhere else", %{board: board} do
      scanned_board = Scanner.run(board)
      updated_cell = Enum.at(Enum.at(scanned_board, 1), 1)

      assert updated_cell == 5
    end
  end

  describe "run(board) when board is full" do
    test "should return unchanged board", %{full_board: full_board} do
      scanned_board = Scanner.run(full_board)

      assert full_board == scanned_board
    end
  end

  describe "run(board) when board cen't be solved" do
    test "should return unsolved board", %{unsolvable_board: unsolvable_board} do
      is_board_solved =
        Scanner.run(unsolvable_board)
        |> List.flatten()
        |> Enum.all?(fn x -> x > 0 end)

      assert is_board_solved == false
    end
  end
end

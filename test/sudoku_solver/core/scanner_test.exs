defmodule SudokuSolver.Core.ScannerTest do
  use ExUnit.Case

  alias SudokuSolver.Core.Scanner, as: Scanner
  alias BoardHelper, as: Helper

  describe "run(board) when board is empty" do
    test "should return unchanged board" do
      board = Helper.empty_board()

      assert Scanner.run(board) == board
    end
  end

  describe "run(board) when board is not empty" do
    test "should update a cell with a value that does not fit anywhere else" do
      board = Helper.board()
      scanned_board = Scanner.run(board)
      updated_cell = Enum.at(Enum.at(scanned_board, 1), 1)

      assert updated_cell == 5
    end
  end

  describe "run(board) when board is full" do
    test "should return unchanged board" do
      board = Helper.full_board()
      scanned_board = Scanner.run(board)

      assert board == scanned_board
    end
  end
end

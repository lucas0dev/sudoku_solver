defmodule SudokuSolver.Core.ScannerTest do
  use ExUnit.Case

  alias SudokuSolver.Core.Scanner, as: Scanner

  def empty_board do
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  end

  def board do
    [
      [1, 2, 3, 7, 8, 9, 4, 5, 6],
      [4, 0, 6, 1, 2, 0, 7, 8, 9],
      [7, 8, 0, 4, 5, 6, 1, 2, 3],
      [9, 1, 2, 3, 4, 5, 6, 7, 8],
      [3, 4, 5, 6, 7, 8, 9, 1, 2],
      [6, 0, 8, 9, 1, 2, 3, 4, 5],
      [8, 9, 1, 2, 3, 4, 5, 6, 7],
      [5, 6, 7, 8, 9, 1, 2, 3, 4],
      [2, 3, 4, 5, 6, 7, 8, 9, 1]
    ]
  end

  def full_board do
    [
      [1, 2, 3, 7, 8, 9, 4, 5, 6],
      [4, 5, 6, 1, 2, 3, 7, 8, 9],
      [7, 8, 9, 4, 5, 6, 1, 2, 3],
      [9, 1, 2, 3, 4, 5, 6, 7, 8],
      [3, 4, 5, 6, 7, 8, 9, 1, 2],
      [6, 7, 8, 9, 1, 2, 3, 4, 5],
      [8, 9, 1, 2, 3, 4, 5, 6, 7],
      [5, 6, 7, 8, 9, 1, 2, 3, 4],
      [2, 3, 4, 5, 6, 7, 8, 9, 1]
    ]
  end

  describe "run(board) when board is empty" do
    test "should return unchanged board" do
      board = empty_board()

      assert Scanner.run(board) == board
    end
  end

  describe "run(board) when board is not empty" do
    test "should update a cell with a value that does not fit anywhere else" do
      board = board()
      scanned_board = Scanner.run(board)
      updated_cell = Enum.at(Enum.at(scanned_board, 1), 1)

      assert updated_cell == 5
    end
  end

  describe "run(board) when board is full" do
    test "should return unchanged board" do
      board = full_board()
      scanned_board = Scanner.run(board)

      assert board == scanned_board
    end
  end
end

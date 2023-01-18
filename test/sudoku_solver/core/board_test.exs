defmodule SudokuSolver.Core.BoardTest do
  use ExUnit.Case

  alias SudokuSolver.Core.Board, as: Board
  alias BoardHelper, as: Helper

  setup_all do
    full_board = Helper.full_board()
    board = Helper.board()
    {:ok, full_board: full_board, board: board}
  end

  describe "board_at(board, {x, y})" do
    test "should return value of a cell on a board", %{full_board: full_board} do
      assert Board.board_at(full_board, {1, 1}) == 5
    end
  end

  describe "update(board, {x, y}, value)" do
    test "should change the value of a cell at given coordinates", %{full_board: full_board} do
      cell_before = Enum.at(Enum.at(full_board, 1), 1)
      updated_board = Board.update(full_board, {1, 1}, 2)
      cell_after = Enum.at(Enum.at(updated_board, 1), 1)

      assert cell_before != cell_after
    end
  end

  describe "remove_cells(board, cells_to_delete)" do
    test "should change the value of given cells to 0", %{full_board: full_board} do
      cell1_before = Enum.at(Enum.at(full_board, 0), 1)
      cell2_before = Enum.at(Enum.at(full_board, 0), 2)

      updated_board = Board.remove_cells(full_board, [{1, 0}, {2, 0}])
      cell1_after = Enum.at(Enum.at(updated_board, 0), 1)
      cell2_after = Enum.at(Enum.at(updated_board, 0), 2)

      assert cell1_before != 0
      assert cell2_before != 0
      assert cell1_after == 0
      assert cell2_after == 0
    end
  end

  describe "empty_cells(board) when board has empty cells" do
    test "should return all cells with 0 value from the board", %{board: board} do
      empty_cells = Enum.sort(Board.empty_cells(board))
      expected_cells = Enum.sort([{1, 1}, {2, 2}, {1, 5}, {5, 1}])

      assert empty_cells == expected_cells
    end
  end

  describe "empty_cells(board) when board does not have empty cells" do
    test "should return empty list", %{full_board: full_board} do
      empty_cells = Enum.sort(Board.empty_cells(full_board))
      expected_cells = []

      assert empty_cells == expected_cells
    end
  end

  describe "possible_in_row(board, {_x, y}) when row is not fully filled" do
    test "should return all possible to fill values within the row in which the cell is located",
         %{board: board} do
      possible_values = Board.possible_in_row(board, {0, 1})
      expected_values = [3, 5]

      assert possible_values == expected_values
    end
  end

  describe "possible_in_row(board, {_x, y}) when row is fully filled" do
    test "should return empty list", %{board: board} do
      possible_values = Board.possible_in_row(board, {2, 4})
      expected_values = []

      assert possible_values == expected_values
    end
  end

  describe "possible_in_col(board, {x, _y}) when column is not fully filled" do
    test "should return all possible to fill values within the column in which the cell is located",
         %{board: board} do
      possible_values = Board.possible_in_col(board, {1, 0})
      expected_values = [5, 7]

      assert possible_values == expected_values
    end
  end

  describe "possible_in_row(board, {_x, y}) when column is filled" do
    test "should return empty list", %{board: board} do
      possible_values = Board.possible_in_col(board, {6, 2})
      expected_values = []

      assert possible_values == expected_values
    end
  end

  describe "possible_in_box(board, {x, y}) when box is not fully filled" do
    test "should return all possible to fill values within the box in which the cell is located",
         %{board: board} do
      possible_values = Board.possible_in_box(board, {1, 2})
      expected_values = [5, 9]

      assert possible_values == expected_values
    end
  end

  describe "possible_in_box(board, {x, y}) when box is filled" do
    test "should return empty list", %{board: board} do
      possible_values = Board.possible_in_box(board, {3, 3})
      expected_values = []

      assert possible_values == expected_values
    end
  end

  describe "row_coordinates(board, {_x, y})" do
    test "should return all coordinates of the row", %{board: board} do
      result = Board.row_coordinates(board, {3, 3})
      expected_values = [{0, 3}, {1, 3}, {2, 3}, {3, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3}, {8, 3}]

      assert result == expected_values
    end
  end

  describe "col_coordinates(board, {_x, y})" do
    test "should return all coordinates of the column", %{board: board} do
      result = Board.col_coordinates(board, {3, 3})
      expected_values = [{3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 4}, {3, 5}, {3, 6}, {3, 7}, {3, 8}]

      assert result == expected_values
    end
  end

  describe "box_coordinates({x, y})" do
    test "should return all coordinates of the box" do
      result = Board.box_coordinates({3, 3})
      expected_values = [{3, 3}, {3, 4}, {3, 5}, {4, 3}, {4, 4}, {4, 5}, {5, 3}, {5, 4}, {5, 5}]

      assert result == expected_values
    end
  end
end

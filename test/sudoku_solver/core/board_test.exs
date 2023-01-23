defmodule SudokuSolver.Core.BoardTest do
  use ExUnit.Case

  alias BoardHelper, as: Helper
  alias SudokuSolver.Core.Board, as: Board

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

  describe "board_correct?(board) when board is empty" do
    test "should return true", %{empty_board: empty_board} do
      result = Board.board_correct?(empty_board)

      assert result == true
    end
  end

  describe "board_correct?(board) when board is solved" do
    test "should return true", %{full_board: full_board} do
      result = Board.board_correct?(full_board)

      assert result == true
    end
  end

  describe "board_correct?(board) when board can be solved" do
    test "should return true", %{board: board} do
      result = Board.board_correct?(board)

      assert result == true
    end
  end

  describe "board_correct?(board) when board can't be solved" do
    test "should return false", %{unsolvable_board: unsolvable_board} do
      result = Board.board_correct?(unsolvable_board)

      assert result == false
    end
  end

  describe "check_if_full(board) when board is solved" do
    test "should return {:full, board}", %{full_board: full_board} do
      result = Board.check_if_full(full_board)

      assert result == {:full, full_board}
    end
  end

  describe "check_if_full(board) with unsolved board" do
    test "should return {:not_full, board}", %{board: board} do
      result = Board.check_if_full(board)

      assert result == {:not_full, board}
    end
  end

  describe "all_allowed_values(board) when board is empty" do
    test "it should generate list of allowed to fill values for each cell", %{
      empty_board: empty_board
    } do
      values = Board.all_allowed_values(empty_board)

      result =
        Enum.all?(values, fn {_coordinates, values} -> values == [1, 2, 3, 4, 5, 6, 7, 8, 9] end)

      assert result == true
    end
  end

  describe "all_allowed_values(board) when board is not empty" do
    test "it should generate list of allowed to fill values for each cell", %{board: board} do
      allowed_values = Board.all_allowed_values(board)
      empty_cells = for x <- 0..8, y <- 0..8, Enum.at(Enum.at(board, y), x) == 0, do: {x, y}

      assert true == Enum.all?(allowed_values, fn {_coordinates, values} -> values != [] end)

      assert true ==
               Enum.all?(allowed_values, fn {coordinates, _value} ->
                 Enum.member?(empty_cells, coordinates)
               end)
    end
  end

  describe "all_allowed_values(board) when board is solved" do
    test "it should return empty list", %{full_board: full_board} do
      allowed_values = Board.all_allowed_values(full_board)

      assert allowed_values == []
    end
  end

  describe "next_possible_value(board, {col, row}) when there is a possible value" do
    test "should return {:ok, value}", %{board: board} do
      {:ok, value} = Board.next_possible_value(board, {6, 8})

      assert value in [8, 9] == true
    end
  end

  describe "next_possible_value(board, {col, row}) when there is no possible value" do
    test "should return  {:error, nil}", %{board: board} do
      {:error, value} = Board.next_possible_value(board, {1, 0})

      assert value == nil
    end
  end

  describe "possible_for_cell(board, cell) when there are some possible values" do
    test "should return all possible values for given cell", %{board: board} do
      {:ok, result} = Board.possible_for_cell(board, {6, 8})

      assert result == [8, 9]
    end
  end

  describe "possible_for_cell(board, cell) when there is no possible value" do
    test "should return empty list", %{board: board} do
      {:error, reason} = Board.possible_for_cell(board, {4, 3})

      assert reason == :no_values
    end
  end

  describe "board_at(board, {x, y})" do
    test "should return value of a cell from the board", %{full_board: full_board} do
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

      expected_cells =
        Enum.sort([{1, 1}, {2, 2}, {1, 5}, {5, 1}, {6, 8}, {7, 8}, {8, 8}, {6, 4}, {6, 5}, {6, 7}])

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
      possible_values = Board.possible_in_row(board, {2, 6})
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
      possible_values = Board.possible_in_col(board, {4, 2})
      expected_values = []

      assert possible_values == expected_values
    end
  end

  describe "possible_in_box(board, {x, y}) when box is not fully filled" do
    test "should return all possible to fill values within the box in which the cell is located",
         %{board: board} do
      possible_values = Board.possible_in_box(board, {2, 2})
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

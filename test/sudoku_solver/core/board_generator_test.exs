defmodule SudokuSolver.Core.BoardGeneratorTest do
  use ExUnit.Case

  alias SudokuSolver.Core.BoardGenerator, as: Generator

  def board do
    [
      [9, 3, 0, 1, 4, 5, 0, 7, 8],
      [1, 0, 4, 0, 0, 0, 0, 0, 0],
      [0, 0, 5, 0, 0, 0, 0, 2, 0],
      [3, 0, 0, 0, 0, 0, 0, 0, 0],
      [4, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 0, 0],
      [6, 0, 0, 0, 0, 0, 0, 0, 0],
      [7, 2, 0, 0, 0, 0, 0, 0, 0],
      [8, 0, 9, 0, 0, 0, 0, 0, 0]

    ]
  end

  setup_all do
    full_board = Generator.generate_full_board()
    required_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    {:ok, full_board: full_board, required_values: required_values}
  end

  describe "generate_full_board()" do
    test "should return board with all cells > 0", %{full_board: full_board}  do
      cells = List.flatten(full_board)

      assert Enum.all?(cells, fn cell -> cell > 0 end) == true
    end

    test "should have all rows filled with numbers from 1 to 9",
      %{full_board: full_board, required_values: required_values} do

        assert Enum.all?(full_board, fn row -> row -- required_values == [] end) == true
    end

    test "should have all columns filled with numbers from 1 to 9",
      %{full_board: full_board, required_values: required_values} do

        cols = for x <- 0..8, do: Enum.map(full_board, fn row -> Enum.at(row, x) end)

        assert Enum.all?(cols, fn col -> col -- required_values == [] end) == true
    end

    test "should have all boxes filled with numbers from 1 to 9",
      %{full_board: full_board, required_values: required_values} do
        box_start_coordinates = [
          {0, 0}, {3, 0}, {6, 0},
          {0, 3}, {3, 3}, {6, 3},
          {0, 6}, {3, 6}, {6, 6}
        ]
        boxes_values = Enum.map(box_start_coordinates, fn {start_x, start_y} ->
          for x <- 0..2, y <- 0..2, do: Enum.at(Enum.at(full_board, start_y + y), start_x + x)
        end)

        assert Enum.all?(boxes_values, fn box_values -> box_values -- required_values == [] end) == true
    end

    test "should generate different board each time", %{full_board: full_board}  do
      board = Generator.generate_full_board()

      assert board != full_board == true
    end


  end
end

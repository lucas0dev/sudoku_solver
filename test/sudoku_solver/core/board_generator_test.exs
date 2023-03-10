defmodule SudokuSolver.Core.BoardGeneratorTest do
  use ExUnit.Case

  alias BoardHelper, as: Helper
  alias SudokuSolver.Core.BoardGenerator, as: Generator

  setup_all do
    full_board = Helper.full_board()
    required_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    {:ok, full_board: full_board, required_values: required_values}
  end

  describe "generate_solvable_board(amount_of_zeroes) when amount_of_zeroes == 0" do
    test "should return board with all cells > 0", %{full_board: full_board} do
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
        {0, 0},
        {3, 0},
        {6, 0},
        {0, 3},
        {3, 3},
        {6, 3},
        {0, 6},
        {3, 6},
        {6, 6}
      ]

      boxes_values =
        Enum.map(box_start_coordinates, fn {start_x, start_y} ->
          for x <- 0..2, y <- 0..2, do: Enum.at(Enum.at(full_board, start_y + y), start_x + x)
        end)

      assert Enum.all?(boxes_values, fn box_values -> box_values -- required_values == [] end) ==
               true
    end

    test "should generate different board each time", %{full_board: full_board} do
      board = Generator.solvable_board(0)

      assert board != full_board == true
    end
  end

  describe "generate_solvable_board(amount_of_zeroes) when amount_of_zeroes > 0" do
    test "should return board with chosen amount of zeroed out cells" do
      empty_amount = Enum.random(1..81)
      board = Generator.solvable_board(empty_amount)
      cells = List.flatten(board)
      number_of_empty = length(Enum.filter(cells, fn cell -> cell == 0 end))

      assert number_of_empty == empty_amount
    end
  end
end

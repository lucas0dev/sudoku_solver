defmodule SudokuSolverTest do
  use ExUnit.Case
  alias BoardHelper, as: Helper

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

  describe "run(board, solution_finder) with solvable board and default solution_finder" do
    test "should solve board and return {:ok, board}", %{board: board} do
      {:ok, board} = SudokuSolver.run(board)
      cells = List.flatten(board)
      result = Enum.all?(cells, fn cell -> cell > 0 end)

      assert result == true
    end
  end

  describe "run(board, solution_finder) with empty board and default solution_finder" do
    test "should solve board and return {:ok, board} ", %{empty_board: empty_board} do
      {:ok, board} = SudokuSolver.run(empty_board)
      cells = List.flatten(board)
      result = Enum.all?(cells, fn cell -> cell > 0 end)

      assert result == true
    end
  end

  describe "run(board, solution_finder) with unsolvable board and default solution_finder" do
    test "should partially solve board and return {:invalid, board}", %{
      unsolvable_board: unsolvable_board
    } do
      {:invalid, board} = SudokuSolver.run(unsolvable_board)
      cells = List.flatten(board)
      result = Enum.all?(cells, fn cell -> cell > 0 end)

      assert board != unsolvable_board
      assert result != true
    end
  end

  @tag :expensive
  describe "run(board, solution_finder) with solution_finder running more than 5 seconds" do
    test "should return unchanged board and {:error, board} response", %{
      board: board
    } do
      finder = fn _ -> Process.sleep(7000) end

      assert {:error, board} == SudokuSolver.run(board, finder)
    end
  end

  describe "update(board, {x, y}, new_value) when params are valid" do
    test "should update the board", %{board: board} do
      value_before = Enum.at(Enum.at(board, 1), 1)
      board_after = SudokuSolver.update(board, {1, 1}, 5)
      value_after = Enum.at(Enum.at(board_after, 1), 1)

      assert value_before != value_after
      assert value_after == 5
    end
  end

  describe "update(board, {x, y}, new_value) when params are invalid" do
    test "should not update the board", %{board: board} do
      input_data = [[{10, 1}, 1], [{1, 1}, 10]]
      [{x, y}, value] = Enum.random(input_data)
      value_before = Enum.at(Enum.at(board, y), x)
      board_after = SudokuSolver.update(board, {x, y}, value)
      value_after = Enum.at(Enum.at(board_after, y), x)

      assert value_before == value_after
      assert board_after == board
    end
  end

  describe "generate_board(empty_amount)" do
    test "should generate board with given amount of empty cells" do
      amount = Enum.random(0..81)
      board = SudokuSolver.generate_board(amount)
      empty_from_board = Enum.count(List.flatten(board), fn cell -> cell == 0 end)

      assert amount == empty_from_board
    end
  end
end

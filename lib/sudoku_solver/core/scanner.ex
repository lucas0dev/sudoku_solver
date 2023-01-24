defmodule SudokuSolver.Core.Scanner do
  @moduledoc """
  For each empty cell in a board, it checks all possible to fill values and
  compares them with all the possible values in each cell in column, row and box.
  If a cell has one possible value that the others don't have,
  it places it in the board.
  """

  alias SudokuSolver.Core.Board

  @type coordinates :: Board.coordinates()

  @spec run(list) :: list
  def run(board) do
    cells_to_scan = Board.empty_cells(board)
    updated_board = Enum.reduce(cells_to_scan, board, fn cell, acc -> scan_cell(acc, cell) end)

    if board != updated_board do
      run(updated_board)
    else
      updated_board
    end
  end

  @spec scan_cell(list, coordinates) :: list
  defp scan_cell(board, cell) do
    possible_for_cell = possible_for_cell(board, cell)
    possible_for_groups = possible_for_groups(board, cell)

    result =
      Enum.map(possible_for_groups, fn group_values -> possible_for_cell -- group_values end)
      |> List.flatten()
      |> Enum.uniq_by(fn x -> x end)
      |> Enum.at(0)

    if result != nil do
      Board.update(board, cell, result)
    else
      board
    end
  end

  @spec possible_for_groups(list, coordinates) :: list
  defp possible_for_groups(board, cell) do
    box_to_check = Board.box_coordinates(cell) -- [cell]
    row_to_check = Board.row_coordinates(board, cell) -- [cell]
    col_to_check = Board.col_coordinates(board, cell) -- [cell]
    col = get_values_for(board, box_to_check)
    row = get_values_for(board, row_to_check)
    box = get_values_for(board, col_to_check)
    [col, row, box]
  end

  @spec get_values_for(list, list(coordinates)) :: list(non_neg_integer()) | []
  defp get_values_for(board, cells_to_check) do
    possible_values =
      for {x, y} <- cells_to_check, Board.board_at(board, {x, y}) == 0, into: [] do
        possible_for_cell(board, {x, y})
      end

    List.flatten(possible_values)
    |> Enum.uniq()
  end

  @spec possible_for_cell(list, coordinates) :: list(non_neg_integer()) | []
  defp possible_for_cell(board, cell) do
    row_possible = Board.possible_in_row(board, cell)
    col_possible = Board.possible_in_col(board, cell)
    box_possible = Board.possible_in_box(board, cell)

    Enum.reject(row_possible, fn x ->
      !Enum.member?(col_possible, x) || !Enum.member?(box_possible, x)
    end)
  end
end

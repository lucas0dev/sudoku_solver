defmodule SudokuSolver.Core.Scanner do
  @moduledoc """
  For each empty cell in a board, it checks all possible to fill values and
  compares them with all the possible values in each cell in column, row and box.
  If a cell has one possible value that the others don't have,
  it places it in the board.
  """

  alias SodukuSolver.Core.BoardGenerator, as: Generator

  @all_possible_values [1, 2, 3, 4, 5, 6, 7, 8, 9]

  @type cell :: Generator.cell()

  @spec run(list) :: list
  def run(board) do
    cells_to_scan = empty_cells(board)
    updated_board = Enum.reduce(cells_to_scan, board, fn cell, acc -> scan_cell(acc, cell) end)

    if board != updated_board do
      run(updated_board)
    else
      updated_board
    end
  end

  @spec scan_cell(list, cell) :: list
  defp scan_cell(board, cell) do
    possible_for_cell = possible_for_cell(board, cell)
    possible_for_groups = possible_for_groups(board, cell)

    result =
      Enum.map(possible_for_groups, fn group_values -> possible_for_cell -- group_values end)
      |> List.flatten()
      |> Enum.uniq_by(fn x -> x end)
      |> Enum.at(0)

    if result != nil do
      add_to_board(board, cell, result)
    else
      board
    end
  end

  @spec possible_for_groups(list, cell) :: list
  defp possible_for_groups(board, cell) do
    box_to_check = box_coordinates(cell) -- [cell]
    row_to_check = row_coordinates(board, cell) -- [cell]
    col_to_check = col_coordinates(board, cell) -- [cell]
    col = get_values_for(board, box_to_check)
    row = get_values_for(board, row_to_check)
    box = get_values_for(board, col_to_check)
    [col, row, box]
  end

  @spec get_values_for(list, list(cell)) :: list(non_neg_integer()) | []
  defp get_values_for(board, cells_to_check) do
    possible_values =
      for {x, y} <- cells_to_check, board_at(board, {x, y}) == 0, into: [] do
        possible_for_cell(board, {x, y})
      end

    List.flatten(possible_values)
    |> Enum.uniq()
  end

  @spec add_to_board(list, cell, non_neg_integer()) :: list
  defp add_to_board(board, {x, y}, value) do
    row = Enum.at(board, y)
    updated_row = List.replace_at(row, x, value)
    List.replace_at(board, y, updated_row)
  end

  @spec empty_cells(list) :: list(cell) | []
  defp empty_cells(board) do
    row_length = length(board)
    col_length = length(Enum.at(board, 0))

    for x <- 0..(col_length - 1),
        y <- 0..(row_length - 1),
        board_at(board, {x, y}) == 0,
        do: {x, y}
  end

  @spec board_at(list, cell) :: non_neg_integer()
  defp board_at(board, {x, y}) do
    Enum.at(Enum.at(board, y), x)
  end

  @spec possible_for_cell(list, {integer, integer}) :: list(non_neg_integer()) | []
  defp possible_for_cell(board, cell) do
    row_possible = possible_in_row(board, cell)
    col_possible = possible_in_col(board, cell)
    box_possible = possible_in_box(board, cell)

    Enum.reject(row_possible, fn x ->
      !Enum.member?(col_possible, x) || !Enum.member?(box_possible, x)
    end)
  end

  @spec possible_in_row(list, cell) :: list(non_neg_integer()) | []
  defp possible_in_row(board, {_x, y}) do
    row_size = length(Enum.at(board, y))
    row_values = for cell_x <- 0..(row_size - 1), do: board_at(board, {cell_x, y})
    @all_possible_values -- row_values
  end

  @spec possible_in_col(list, cell) :: list(non_neg_integer()) | []
  defp possible_in_col(board, {x, _y}) do
    col_length = length(board)
    col_values = for cell_y <- 0..(col_length - 1), do: board_at(board, {x, cell_y})
    @all_possible_values -- col_values
  end

  @spec possible_in_box(list, cell) :: list(non_neg_integer()) | []
  defp possible_in_box(board, {x, y}) do
    cells_to_check = box_coordinates({x, y})
    values_in_box = for {cell_x, cell_y} <- cells_to_check, do: board_at(board, {cell_x, cell_y})
    @all_possible_values -- values_in_box
  end

  @spec row_coordinates(list, cell) :: list(cell)
  defp row_coordinates(board, {_x, y}) do
    col_length = length(board)
    for x <- 0..(col_length - 1), do: {x, y}
  end

  @spec col_coordinates(list, cell) :: list(cell)
  defp col_coordinates(board, {x, _y}) do
    row_length = length(Enum.at(board, 0))
    for y <- 0..(row_length - 1), do: {x, y}
  end

  @spec box_coordinates(cell) :: list(cell)
  defp box_coordinates({x, y}) do
    start_x = div(x, 3) * 3
    start_y = div(y, 3) * 3
    for offset_x <- [0, 1, 2], offset_y <- [0, 1, 2], do: {offset_x + start_x, offset_y + start_y}
  end
end

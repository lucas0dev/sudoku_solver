defmodule SudokuSolver.Core.Board do
  @moduledoc """
  It has functions strictly connected to manipulating and checking the board.
  """

  @all_possible_values [1, 2, 3, 4, 5, 6, 7, 8, 9]

  @type cell :: {non_neg_integer(), non_neg_integer()}

  @spec empty_board :: [[0, ...], ...]
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

  @spec board_at(list, cell) :: non_neg_integer() | nil
  def board_at(board, {x, y}) do
    Enum.at(Enum.at(board, y), x)
  end

  @spec update(list, cell, non_neg_integer()) :: list
  def update(board, {x, y}, value) do
    row = Enum.at(board, y)
    updated_row = List.replace_at(row, x, value)
    List.replace_at(board, y, updated_row)
  end

  @spec remove_cells(list, list(cell)) :: list
  def remove_cells(board, cells_to_delete) do
    for {row, y} <- Enum.with_index(board) do
      Enum.map(Enum.with_index(row), fn {col, x} ->
        if Enum.member?(cells_to_delete, {x, y}), do: 0, else: col
      end)
    end
  end

  @spec empty_cells(list) :: list(cell) | []
  def empty_cells(board) do
    row_length = length(board)
    col_length = length(Enum.at(board, 0))

    for x <- 0..(col_length - 1),
        y <- 0..(row_length - 1),
        board_at(board, {x, y}) == 0,
        do: {x, y}
  end

  @spec possible_in_row(list, cell) :: list(non_neg_integer()) | []
  def possible_in_row(board, {_x, y}) do
    row_size = length(Enum.at(board, y))
    row_values = for cell_x <- 0..(row_size - 1), do: board_at(board, {cell_x, y})
    @all_possible_values -- row_values
  end

  @spec possible_in_col(list, cell) :: list(non_neg_integer()) | []
  def possible_in_col(board, {x, _y}) do
    col_length = length(board)
    col_values = for cell_y <- 0..(col_length - 1), do: board_at(board, {x, cell_y})
    @all_possible_values -- col_values
  end

  @spec possible_in_box(list, cell) :: list(non_neg_integer()) | []
  def possible_in_box(board, {x, y}) do
    cells_to_check = box_coordinates({x, y})
    values_in_box = for {cell_x, cell_y} <- cells_to_check, do: board_at(board, {cell_x, cell_y})
    @all_possible_values -- values_in_box
  end

  @spec row_coordinates(list, cell) :: list(cell)
  def row_coordinates(board, {_x, y}) do
    col_length = length(board)
    for x <- 0..(col_length - 1), do: {x, y}
  end

  @spec col_coordinates(list, cell) :: list(cell)
  def col_coordinates(board, {x, _y}) do
    row_length = length(Enum.at(board, 0))
    for y <- 0..(row_length - 1), do: {x, y}
  end

  @spec box_coordinates(cell) :: list(cell)
  def box_coordinates({x, y}) do
    start_x = div(x, 3) * 3
    start_y = div(y, 3) * 3
    for offset_x <- [0, 1, 2], offset_y <- [0, 1, 2], do: {offset_x + start_x, offset_y + start_y}
  end
end

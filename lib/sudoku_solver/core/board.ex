defmodule SudokuSolver.Core.Board do
  @moduledoc """
  It has functions strictly connected to manipulating and checking the board.
  """

  @all_possible_values [1, 2, 3, 4, 5, 6, 7, 8, 9]

  @type coordinates :: {non_neg_integer(), non_neg_integer()}

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

  @spec board_correct?(list) :: true | false
  def board_correct?(board) do
    cols_coordinates = for x <- 0..8, do: col_coordinates(board, {x, 0})
    boxes_coordinates = for {x, y} <- boxes_start_coordinates(), do: box_coordinates({x, y})

    cols_values =
      for list <- cols_coordinates, do: Enum.map(list, fn {x, y} -> board_at(board, {x, y}) end)

    boxes_values =
      for list <- boxes_coordinates, do: Enum.map(list, fn {x, y} -> board_at(board, {x, y}) end)

    filtered_values =
      Enum.map([cols_values, boxes_values, board], fn values -> remove_zeroes(values) end)

    filtered_values
    |> Enum.map(fn values -> group_valid?(values) end)
    |> Enum.all?(fn status -> status == true end)
  end

  @spec check_if_full(list) :: {:full, list} | {:not_full, list}
  def check_if_full(board) do
    cells = List.flatten(board)

    case Enum.all?(cells, fn cell_value -> cell_value > 0 end) do
      true -> {:full, board}
      _ -> {:not_full, board}
    end
  end

  @spec all_allowed_values(list) :: list
  def all_allowed_values(board) do
    last_row = length(board) - 1
    last_col = length(Enum.at(board, 0)) - 1

    for x <- 0..last_col, y <- 0..last_row, board_at(board, {x, y}) == 0, into: [] do
      {:ok, values} = possible_for_cell(board, {x, y})
      {{x, y}, values}
    end
  end

  @spec next_possible_value(list, coordinates) :: {:ok, non_neg_integer()} | {:error, nil}
  def next_possible_value(board, {col, row}) do
    case possible_for_cell(board, {col, row}) do
      {:ok, values} ->
        first_value =
          values
          |> Enum.shuffle()
          |> Enum.at(0)

        {:ok, first_value}

      _ ->
        {:error, nil}
    end
  end

  @spec possible_for_cell(list, coordinates) :: {:ok, list} | {:error, :no_values}
  def possible_for_cell(board, cell) do
    for_row = possible_in_row(board, cell)
    for_col = possible_in_col(board, cell)
    for_box = possible_in_box(board, cell)

    values =
      Enum.reject(for_row, fn x -> !Enum.member?(for_col, x) || !Enum.member?(for_box, x) end)

    if values != [], do: {:ok, values}, else: {:error, :no_values}
  end

  @spec board_at(list, coordinates) :: non_neg_integer() | nil
  def board_at(board, {x, y}) do
    Enum.at(Enum.at(board, y), x)
  end

  @spec update(list, coordinates, non_neg_integer()) :: list
  def update(board, {x, y}, value) when value in 0..9 do
    row = Enum.at(board, y)
    updated_row = List.replace_at(row, x, value)
    List.replace_at(board, y, updated_row)
  end

  def update(board, _, _) do
    board
  end

  @spec remove_cells(list, list(coordinates)) :: list
  def remove_cells(board, cells_to_delete) do
    for {row, y} <- Enum.with_index(board) do
      Enum.map(Enum.with_index(row), fn {col, x} ->
        if Enum.member?(cells_to_delete, {x, y}), do: 0, else: col
      end)
    end
  end

  @spec empty_cells(list) :: list(coordinates) | []
  def empty_cells(board) do
    last_row = length(board) - 1
    last_col = length(Enum.at(board, 0)) - 1

    for x <- 0..last_col,
        y <- 0..last_row,
        board_at(board, {x, y}) == 0,
        do: {x, y}
  end

  @spec possible_in_row(list, coordinates) :: list(non_neg_integer()) | []
  def possible_in_row(board, {_x, y}) do
    last_row = length(Enum.at(board, y)) - 1
    row_values = for cell_x <- 0..last_row, do: board_at(board, {cell_x, y})
    @all_possible_values -- row_values
  end

  @spec possible_in_col(list, coordinates) :: list(non_neg_integer()) | []
  def possible_in_col(board, {x, _y}) do
    last_col = length(board) - 1
    col_values = for cell_y <- 0..last_col, do: board_at(board, {x, cell_y})
    @all_possible_values -- col_values
  end

  @spec possible_in_box(list, coordinates) :: list(non_neg_integer()) | []
  def possible_in_box(board, {x, y}) do
    cells_to_check = box_coordinates({x, y})
    values_in_box = for {cell_x, cell_y} <- cells_to_check, do: board_at(board, {cell_x, cell_y})
    @all_possible_values -- values_in_box
  end

  @spec row_coordinates(list, coordinates) :: list(coordinates)
  def row_coordinates(board, {_x, y}) do
    last_col = length(board) - 1
    for x <- 0..last_col, do: {x, y}
  end

  @spec col_coordinates(list, coordinates) :: list(coordinates)
  def col_coordinates(board, {x, _y}) do
    last_row = length(Enum.at(board, 0)) - 1
    for y <- 0..last_row, do: {x, y}
  end

  @spec box_coordinates(coordinates) :: list(coordinates)
  def box_coordinates({x, y}) do
    start_x = div(x, 3) * 3
    start_y = div(y, 3) * 3
    for offset_x <- [0, 1, 2], offset_y <- [0, 1, 2], do: {offset_x + start_x, offset_y + start_y}
  end

  defp boxes_start_coordinates() do
    [{0, 0}, {3, 0}, {6, 0}, {0, 3}, {3, 3}, {6, 3}, {0, 6}, {3, 6}, {6, 6}]
  end

  @spec remove_zeroes(list) :: list
  defp remove_zeroes(nested_list) do
    Enum.map(nested_list, fn list -> Enum.reject(list, fn value -> value == 0 end) end)
  end

  @spec group_valid?(list) :: true | false
  defp group_valid?(nested_list) do
    Enum.all?(nested_list, fn list -> list == Enum.uniq(list) end)
  end
end

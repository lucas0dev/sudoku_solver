defmodule SudokuSolver.Core.BoardGenerator do
  @moduledoc """
  Generates a solved sudoku board, then removes the specified
  number of cells so that it can be solved manually or automatically
  by solver.
  """

  def generate_full_board do
    full_board(empty_board(), 0, [])
  end

  @spec full_board(list, non_neg_integer(), []) :: nonempty_list
  defp full_board(_board, _cell_to_fill, []) do
    full_board(empty_board(), 0, shuffled_values())
  end

  @spec full_board(list, non_neg_integer(), nonempty_list(non_neg_integer())) :: nonempty_list
  defp full_board(board, cell_to_fill, values) do
    if cell_to_fill == 81 do
      board
    else
      row = div(cell_to_fill, 9)
      col = rem(cell_to_fill, 9)
      [number | rest] = values
      updated_board = update_board(board, {col, row}, number)

      with true <- board_at(board, {col, row}) == 0,
            {:check_ok} <- check_row(board, {col, row}, number),
            {:check_ok} <- check_col(board, {col, row}, number),
            {:check_ok} <- check_box(board, {col, row}, number) do
        full_board(updated_board, cell_to_fill + 1, shuffled_values())
      else
        false -> full_board(board, cell_to_fill + 1, shuffled_values())
        {:check_error, _reason} -> full_board(board, cell_to_fill, rest)
      end
    end
  end

  @spec shuffled_values :: nonempty_list(non_neg_integer())
  defp shuffled_values do
    Enum.shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  @spec update_board(list, {non_neg_integer(), non_neg_integer()}, non_neg_integer()) :: list
  defp update_board(board, {x, y}, value) do
    row = Enum.at(board, y)
    updated_row = List.replace_at(row, x, value)
    List.replace_at(board, y, updated_row)
  end

  @spec board_at(list, {non_neg_integer(), non_neg_integer()}) :: non_neg_integer()
  defp board_at(board, {x, y}) do
    Enum.at(Enum.at(board, y), x)
  end

  @spec check_row(list, {non_neg_integer(), non_neg_integer()}, non_neg_integer()) ::
          {:check_ok} | {:check_error, :row}
  defp check_row(board, {_x, y}, value) do
    row = Enum.at(board, y)
    row_occupied = Enum.member?(row, value)

    if row_occupied == false do
      {:check_ok}
    else
      {:check_error, :row}
    end
  end

  @spec check_col(list, {non_neg_integer(), non_neg_integer()}, non_neg_integer()) ::
          {:check_ok} | {:check_error, :col}
  defp check_col(board, {x, _y}, value) do
    col = Enum.map(board, fn row -> Enum.at(row, x) end)
    col_occupied = Enum.member?(col, value)

    if col_occupied == false do
      {:check_ok}
    else
      {:check_error, :col}
    end
  end

  @spec check_box(list, {non_neg_integer(), non_neg_integer()}, non_neg_integer()) ::
          {:check_ok} | {:check_error, :box}
  defp check_box(board, {cell_x, cell_y}, value) do
    start_x = div(cell_x, 3) * 3
    start_y = div(cell_y, 3) * 3

    box = for offset_x <- [0, 1, 2], offset_y <- [0, 1, 2] do
      row = Enum.at(board, offset_y + start_y)
      Enum.at(row, (offset_x + start_x))
    end

    box_occupied = Enum.member?(box, value)

    if box_occupied == false do
      {:check_ok}
    else
      {:check_error, :box}
    end
  end

  @spec empty_board :: [[0, ...], ...]
  defp empty_board do
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
end

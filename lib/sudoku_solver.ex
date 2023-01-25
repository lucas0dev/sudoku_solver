defmodule SudokuSolver do
  @moduledoc """
  The module solves sudoku by combining the functions of a scanner and two solvers.
  It returns a solved board if the solution does not exceed the allowed time - default is 5 seconds.
  If it takes more time, it returns {:error, board} as a response.
  It serves as a public API for this application.
  """

  alias SudokuSolver.Core.BacktrackingSolver, as: BTSolver
  alias SudokuSolver.Core.Board
  alias SudokuSolver.Core.BoardGenerator, as: Generator
  alias SudokuSolver.Core.Scanner
  alias SudokuSolver.Core.SimpleSolver

  @type coordinates :: Board.coordinates()

  @spec run(list) :: {atom, list}
  def run(board) do
    task =
      Task.async(fn ->
        run_workers(board)
      end)

    case Task.yield(task, 5000) || Task.shutdown(task) do
      {:ok, [ok: {status, board}]} ->
        {status, board}

      nil ->
        {:error, board}
    end
  end

  @spec update(list, coordinates, non_neg_integer()) :: list
  def update(board, {x, y}, new_value) do
    Board.update(board, {x, y}, new_value)
  end

  @spec generate_board(non_neg_integer()) :: nonempty_list
  def generate_board(empty_amount) do
    Generator.solvable_board(empty_amount)
  end

  @spec run_workers(list) :: [ok: {atom, list}]
  defp run_workers(board) do
    result =
      1..12
      |> Task.async_stream(
        fn i ->
          case rem(i, 2) do
            0 -> scan_and_solve(board, BTSolver)
            1 -> scan_and_solve(board, SimpleSolver)
          end
        end,
        ordered: false,
        timeout: 5000,
        on_timeout: :kill_task
      )
      |> Stream.filter(fn result -> {:ok, _} = result end)
      |> Enum.take(1)

    result
  end

  @spec scan_and_solve(list, BTSolver | SimpleSolver) :: {atom, list}
  defp scan_and_solve(board, solver) do
    board
    |> Scanner.run()
    |> solver.solve()
  end
end

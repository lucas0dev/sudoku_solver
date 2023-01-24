defmodule SudokuSolverWeb.Live.BoardLive.Show do
  use SudokuSolverWeb, :live_view

  alias SudokuSolver.Core.Board, as: Board
  alias SudokuSolver.Core.BoardGenerator, as: Generator
  alias SudokuSolver.Core.BacktrackingSolver, as: BTSolver

  @impl true
  def mount(_params, _session, socket) do
    board = Generator.solvable_board(60)

    board =
      if connected?(socket) do
        board
      else
        %{}
      end

    {:ok, assign(socket, board: board, old_board: board)}
  end

  @impl true
  def handle_event("generate", _, socket) do
    board = Generator.solvable_board(60)

    {:noreply, assign(socket, board: board, old_board: board)}
  end

  def handle_event("reset", _, socket) do
    board = socket.assigns.old_board

    {:noreply, assign(socket, board: board)}
  end

  @impl true
  def handle_event("solve", _, socket) do
    board = socket.assigns.board
    new_board = BTSolver.solve(board)
    {:noreply, assign(socket, board: new_board)}
  end

  @impl true
  def handle_event("add_to_board", data, socket) do
    board = socket.assigns.board

    board = add_to_board(board, data)
    {:noreply, assign(socket, board: board)}
  end

  defp add_to_board(board, data) do
    x = Map.get(data, "x") |> String.to_integer()
    y = Map.get(data, "y") |> String.to_integer()
    value = Map.get(data, "value")

    new_value =
      try do
        String.to_integer(value)
      rescue
        ArgumentError -> 0
      end

    if x in 0..8 and y in 0..8 and new_value in 1..9 do
      Board.update(board, {x, y}, new_value)
    else
      board
    end
  end
end

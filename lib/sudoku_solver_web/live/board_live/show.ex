defmodule SudokuSolverWeb.BoardLive.Show do
  use SudokuSolverWeb, :live_view

  alias SudokuSolver.Core.Board, as: Board
  alias SudokuSolver.Core.BoardGenerator, as: Generator
  alias SudokuSolver.Core.SimpleSolver, as: SimpleSolver
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
end

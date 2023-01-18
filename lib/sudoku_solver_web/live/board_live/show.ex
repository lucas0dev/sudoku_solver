defmodule SudokuSolverWeb.BoardLive.Show do
  use SudokuSolverWeb, :live_view

  alias SudokuSolver.Core.BoardGenerator, as: Generator
  alias SudokuSolver.Core.Scanner, as: Scanner

  @impl true
  def mount(_params, _session, socket) do
    board = Generator.solvable_board(50)

    board =
      if connected?(socket) do
        board
      else
        %{}
      end

    {:ok, assign(socket, board: board)}
  end

  @impl true
  def handle_event("generate", _, socket) do
    board = Generator.solvable_board(50)

    {:noreply, assign(socket, board: board, old_board: board)}
  end

  @impl true
  def handle_event("scan", _, socket) do
    board = socket.assigns.board
    new_board = Scanner.run(board)
    {:noreply, assign(socket, board: new_board)}
  end
end

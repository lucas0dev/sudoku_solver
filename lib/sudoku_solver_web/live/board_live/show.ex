defmodule SudokuSolverWeb.BoardLive.Show do
  use SudokuSolverWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    board = [
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0]
    ]
    board = if connected?(socket) do
      board
    else
      %{}
    end

    {:ok, assign(socket, board: board)}
  end
end

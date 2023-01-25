defmodule SudokuSolverWeb.Live.BoardLive.Show do
  use SudokuSolverWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    amount = 60
    board = SudokuSolver.generate_board(amount)

    board =
      if connected?(socket) do
        board
      else
        %{}
      end

    {:ok, assign(socket, board: board, old_board: board, amount: amount, message: "")}
  end

  def handle_event("reset", _, socket) do
    board = socket.assigns.old_board

    {:noreply, assign(socket, board: board, message: "")}
  end

  def handle_event("generate", data, socket) do
    amount = Map.get(data, "amount")
    default_amount = 60

    amount =
      try do
        String.to_integer(amount)
      rescue
        ArgumentError -> default_amount
      end

    board =
      if amount in 0..81 do
        SudokuSolver.generate_board(amount)
      else
        SudokuSolver.generate_board(default_amount)
      end

    {:noreply, assign(socket, board: board, old_board: board, amount: amount, message: "")}
  end

  @impl true
  def handle_event("solve", _, socket) do
    {status, board} =
      socket.assigns.board
      |> SudokuSolver.run()

    {:noreply, assign(socket, board: board, message: status)}
  end

  @impl true
  def handle_event("add_to_board", data, socket) do
    board = add_to_board(socket.assigns.board, data)

    {:noreply, assign(socket, board: board, old_board: board)}
  end

  defp add_to_board(board, data) do
    x = Map.get(data, "x") |> String.to_integer()
    y = Map.get(data, "y") |> String.to_integer()
    value = Map.get(data, "value")

    value_as_integer =
      try do
        String.to_integer(value)
      rescue
        ArgumentError -> 0
      end

    if x in 0..8 and y in 0..8 and value_as_integer in 0..9 do
      SudokuSolver.update(board, {x, y}, value_as_integer)
    else
      board
    end
  end
end

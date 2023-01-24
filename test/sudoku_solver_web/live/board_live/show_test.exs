defmodule SudokuSolverWeb.Live.BoardLive.ShowTest do
  use SudokuSolverWeb.ConnCase
  use SudokuSolverWeb, :live_view
  alias BoardHelper, as: Helper
  alias SudokuSolverWeb.Live.BoardLive, as: BoardLive

  setup_all do
    socket = %Phoenix.LiveView.Socket{}
    board = Helper.board()
    socket = assign(socket, board: board)
    %{socket: socket}
  end

  describe "handle_event('add_to_board', data, socket) when given data is valid" do
    test "updates the board", %{socket: socket} do
      board_before = socket.assigns.board
      value_before = Enum.at(Enum.at(board_before, 1), 1)
      data = %{"x" => "1", "y" => "1", "value" => "5"}
      {:noreply, socket} = BoardLive.Show.handle_event("add_to_board", data, socket)
      board_after = socket.assigns.board
      value_after = Enum.at(Enum.at(board_after, 1), 1)

      assert board_before != board_after
      assert value_before != value_after
      assert value_before != 5
      assert value_after == 5
    end
  end

  describe "handle_event('add_to_board', data, socket) when given data is invalid" do
    test "does not change the board", %{socket: socket} do
      board_before = socket.assigns.board
      data = %{"x" => "1", "y" => "1", "value" => "12"}
      {:noreply, socket} = BoardLive.Show.handle_event("add_to_board", data, socket)
      board_after = socket.assigns.board

      assert board_before == board_after
    end
  end
end

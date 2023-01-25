defmodule SudokuSolverWeb.Live.BoardLive.MessageComponent do
  use SudokuSolverWeb, :live_component

  def render(assigns) do
    ~L"""
    <%= if @message do %>
     <%= if @message == :ok do %>
      <p class="msg-positive"> Sudoku solved! </p>
     <% end %>

     <%= if @message == :error  do %>
      <p class="msg-neutral"> Current sudoku is hard to solve. Try solving it again or generate a new one. </p>
     <% end %>

     <%= if @message == :invalid  do %>
     <p class="msg-invalid"> Cells are filled incorectly. Sudoku can't be solved. </p>
    <% end %>

    <% end %>
    """
  end
end

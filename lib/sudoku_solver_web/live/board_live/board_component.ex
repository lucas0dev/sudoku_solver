defmodule SudokuSolverWeb.BoardLive.BoardComponent do
  use SudokuSolverWeb, :live_component

  def render(assigns) do
    ~L"""
    <%= for {row, row_count} <- Enum.with_index(@board) do %>
      <tr class="row row<%= row_count %>">
        <%= for {value, col_count} <- Enum.with_index(row) do %>
          <%= live_component SudokuSolverWeb.BoardLive.CellComponent, row_count: row_count, col_count: col_count, value: value %>
        <% end %>
      </tr>
    <% end %>
    """
  end
end

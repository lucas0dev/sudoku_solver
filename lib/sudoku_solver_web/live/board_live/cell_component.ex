defmodule SudokuSolverWeb.Live.BoardLive.CellComponent do
  use SudokuSolverWeb, :live_component

  def render(assigns) do
    ~L"""
    <td class="cell cell<%= @col_count %>">
      <%= if @value !=0 do %>
      <input type="text" phx-keyup="add_to_board"  phx-value-x=<%= @col_count %>  phx-value-y=<%= @row_count %>  maxlength="1" onkeypress="return /[0-9]/i.test(event.key)" class="cell_value" value="<%= @value %>">
      <% else %>
        <input type="text" phx-keyup="add_to_board"  phx-value-x=<%= @col_count %>  phx-value-y=<%= @row_count %> maxlength="1" onkeypress="return /[0-9]/i.test(event.key)" class="cell_value" value="">
      <% end %>
    </td>
    """
  end
end

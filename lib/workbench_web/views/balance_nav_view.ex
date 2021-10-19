defmodule WorkbenchWeb.BalanceNavView do
  use WorkbenchWeb, :view

  def render("show.html", assigns) do
    ~H"""
      <nav class="flex flex-row items-center space-x-4">
        <%= link "All", to: Routes.balance_all_path(assigns.conn, :index), class: "text-black hover:text-opacity-75" %>
        <%= link "Hour", to: Routes.balance_hour_path(assigns.conn, :index), class: "text-black hover:text-opacity-75" %>
        <%= link "Day", to: Routes.balance_day_path(assigns.conn, :index), class: "text-black hover:text-opacity-75" %>
        <%= link "Table", to: Routes.balance_table_path(assigns.conn, :index), class: "text-black hover:text-opacity-75" %>
        <%= link "Config", to: Routes.balance_config_path(assigns.conn, :index), class: "text-black hover:text-opacity-75" %>
      </nav>
    """
  end
end

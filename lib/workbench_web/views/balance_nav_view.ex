defmodule WorkbenchWeb.BalanceNavView do
  use WorkbenchWeb, :view

  def render("show.html", assigns) do
    ~E"""
      <nav class="flex flex-row items-center space-x-4">
        <%= link "All", to: Routes.live_path(assigns.conn, WorkbenchWeb.BalanceAllLive.Index), class: "text-black hover:text-opacity-75" %>
        <%= link "Hour", to: Routes.live_path(assigns.conn, WorkbenchWeb.BalanceHourLive.Index), class: "text-black hover:text-opacity-75" %>
        <%= link "Day", to: Routes.live_path(assigns.conn, WorkbenchWeb.BalanceDayLive.Index), class: "text-black hover:text-opacity-75" %>
        <%= link "Table", to: Routes.live_path(assigns.conn, WorkbenchWeb.BalanceTableLive.Index), class: "text-black hover:text-opacity-75" %>
        <%= link "Config", to: Routes.balance_config_path(assigns.conn, :index), class: "text-black hover:text-opacity-75" %>
      </nav>
    """
  end
end

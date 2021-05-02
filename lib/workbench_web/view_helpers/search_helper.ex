defmodule WorkbenchWeb.ViewHelpers.SearchHelper do
  def assign_search(conn, params) do
    query = Map.get(params, "query") || conn.assigns.query

    conn
    |> Phoenix.LiveView.assign(:query, query)
  end
end

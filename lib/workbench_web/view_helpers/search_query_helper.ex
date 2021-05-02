defmodule WorkbenchWeb.ViewHelpers.SearchQueryHelper do
  def assign_search_query(conn, params) do
    query = Map.get(params, "query") || conn.assigns.query

    conn
    |> Phoenix.LiveView.assign(:query, query)
  end
end

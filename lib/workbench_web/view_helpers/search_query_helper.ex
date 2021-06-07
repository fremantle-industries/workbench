defmodule WorkbenchWeb.ViewHelpers.SearchQueryHelper do
  def assign_search_query(conn, params) do
    query = query_from_params(params) || conn.assigns.query
    Phoenix.LiveView.assign(conn, :query, query)
  end

  defp query_from_params(params) do
    query = Map.get(params, "query")

    if query == "" do
      nil
    else
      query
    end
  end
end

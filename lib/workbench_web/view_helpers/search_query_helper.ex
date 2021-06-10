defmodule WorkbenchWeb.ViewHelpers.SearchQueryHelper do
  def assign_search_query(conn, params) do
    query = extract_query(params, conn)
    Phoenix.LiveView.assign(conn, :query, query)
  end

  defp extract_query(params, conn) do
    case Map.get(params, "query") do
      "" -> nil
      nil -> conn.assigns.query
      query -> query
    end
  end
end

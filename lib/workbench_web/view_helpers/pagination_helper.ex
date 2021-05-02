defmodule WorkbenchWeb.ViewHelpers.PaginationHelper do
  def assign_pagination(conn, params) do
    {page, _} = params |> Map.get("page", "1") |> Integer.parse()
    {page_size, _} = params |> Map.get("page_size", "25") |> Integer.parse()

    conn
    |> Phoenix.LiveView.assign(:page_size, page_size)
    |> Phoenix.LiveView.assign(:current_page, page)
  end
end

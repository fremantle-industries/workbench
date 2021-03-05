defmodule WorkbenchWeb.ProductController do
  use WorkbenchWeb, :controller

  def show(conn, %{"venue" => venue, "id" => id}) do
    venue_id = venue |> String.to_atom()
    product_symbol = id |> String.to_atom()

    {venue_id, product_symbol}
    |> Tai.Venues.ProductStore.find()
    |> case do
      {:ok, product} ->
        render(conn, "show.html", product: product)

      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(WorkbenchWeb.ErrorView)
        |> render("404.html")
    end
  end
end

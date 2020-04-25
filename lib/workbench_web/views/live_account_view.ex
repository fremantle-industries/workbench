defmodule WorkbenchWeb.LiveAccountView do
  use Phoenix.LiveView

  def render(assigns) do
    WorkbenchWeb.AccountView.render("index.html", assigns)
  end

  @default_show_zero false
  def mount(_, socket) do
    assigns = %{
      accounts: accounts(show_zero: @default_show_zero),
      show_zero: @default_show_zero
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_params(params, _uri, socket) do
    show_zero = Map.get(params, "show_zero", "false") == "true"

    assigns = %{
      accounts: accounts(show_zero: show_zero),
      show_zero: show_zero
    }

    {:noreply, assign(socket, assigns)}
  end

  @order ~w(venue_id asset account_id)a
  defp accounts(show_zero: show_zero) do
    [show_zero: show_zero]
    |> Workbench.Accounts.where()
    |> Enumerati.order(@order)
  end
end

defmodule WorkbenchWeb.AccountLive.Index do
  use WorkbenchWeb, :live_view

  @default_show_zero false
  def mount(_params, _session, socket) do
    Tai.SystemBus.subscribe(:account_store)

    socket =
      socket
      |> assign(:accounts, accounts(show_zero: @default_show_zero))
      |> assign(:show_zero, @default_show_zero)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    show_zero = Map.get(params, "show_zero", "false") == "true"

    socket =
      socket
      |> assign(show_zero: show_zero)
      |> assign(:accounts, accounts(show_zero: show_zero))

    {:noreply, socket}
  end

  def handle_info({:account_store, :after_put, _account}, socket) do
    socket =
      socket
      |> assign(:accounts, accounts(show_zero: socket.assigns.show_zero))

    {:noreply, socket}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @order ~w(venue_id asset credential_id)a
  defp accounts(show_zero: show_zero) do
    [show_zero: show_zero]
    |> Workbench.Accounts.where()
    |> Enumerati.order(@order)
  end
end

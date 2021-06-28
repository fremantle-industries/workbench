defmodule WorkbenchWeb.WalletLive.Index do
  use WorkbenchWeb, :live_view
  alias Workbench.Wallets

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Wallets.changeset())

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> assign(:query, nil)
      |> assign_wallets()

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"wallet" => wallet_params}, socket) do
    changeset =
      case Wallets.insert(wallet_params) do
        {:ok, _} -> Wallets.changeset(wallet_params)
        {:error, changeset} -> changeset
      end

    socket =
      socket
      |> assign_wallets()
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"wallet-id" => id}, socket) do
    {:ok, _} = Workbench.Wallets.delete(id)

    socket =
      socket
      |> assign_wallets()

    {:noreply, socket}
  end

  defp assign_wallets(socket) do
    socket
    |> assign(:wallets, Wallets.search(socket.assigns.query))
  end
end

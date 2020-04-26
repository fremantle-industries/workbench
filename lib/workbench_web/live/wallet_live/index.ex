defmodule WorkbenchWeb.WalletLive.Index do
  use WorkbenchWeb, :live_view
  require Ecto.Query

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:wallets, sorted_wallets())
      |> assign(:changeset, Workbench.Wallet.changeset(%Workbench.Wallet{}, %{}))

    {:ok, socket}
  end

  def handle_event("save", %{"wallet" => wallet_params}, socket) do
    changeset = Workbench.Wallet.changeset(%Workbench.Wallet{}, wallet_params)
    Workbench.Repo.insert(changeset)

    socket =
      socket
      |> assign(:wallets, sorted_wallets())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  def handle_event("delete", %{"wallet-id" => wallet_id}, socket) do
    id = wallet_id |> String.to_integer()
    %Workbench.Wallet{id: id} |> Workbench.Repo.delete()

    socket =
      socket
      |> assign(:wallets, sorted_wallets())

    {:noreply, socket}
  end

  defp sorted_wallets do
    Ecto.Query.from(
      b in "wallets",
      order_by: [asc: :name],
      select: [:id, :name, :asset, :amount, :address]
    )
    |> Workbench.Repo.all()
  end
end

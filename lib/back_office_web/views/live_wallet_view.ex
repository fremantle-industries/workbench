defmodule BackOfficeWeb.LiveWalletView do
  use Phoenix.LiveView
  require Ecto.Query

  def render(assigns) do
    BackOfficeWeb.WalletView.render("index.html", assigns)
  end

  def mount(_, socket) do
    assigns = %{
      wallets: wallets(),
      changeset: BackOffice.Wallet.changeset(%BackOffice.Wallet{}, %{})
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("save", %{"wallet" => wallet_params}, socket) do
    changeset = BackOffice.Wallet.changeset(%BackOffice.Wallet{}, wallet_params)
    BackOffice.Repo.insert(changeset)
    assigns = %{wallets: wallets(), changeset: changeset}

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("delete", %{"wallet-id" => wallet_id}, socket) do
    id = wallet_id |> String.to_integer()
    %BackOffice.Wallet{id: id} |> BackOffice.Repo.delete()
    assigns = %{wallets: wallets()}

    {:noreply, assign(socket, assigns)}
  end

  defp wallets do
    Ecto.Query.from(
      b in "wallets",
      order_by: [asc: :name],
      select: [:id, :name, :asset, :amount, :address]
    )
    |> BackOffice.Repo.all()
  end
end

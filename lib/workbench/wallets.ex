defmodule Workbench.Wallets do
  require Ecto.Query
  import Ecto.Query
  alias Workbench.{Repo, Wallet}

  def search(_term, _opts \\ []) do
    from(
      Wallet,
      order_by: [asc: :name],
      select: [:id, :name, :asset, :amount, :address]
    )
    |> Repo.all()
  end

  def changeset(attrs \\ %{}) do
    Wallet.changeset(%Wallet{}, attrs)
  end

  def insert(attrs) do
    changeset = Workbench.Wallet.changeset(%Wallet{}, attrs)
    Repo.insert(changeset)
  end

  def delete(id) when is_number(id), do: %Wallet{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end

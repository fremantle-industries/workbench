defmodule Workbench.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field(:name, :string)
    field(:asset, :string)
    field(:amount, :decimal)
    field(:address, :string)

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:name, :asset, :amount, :address])
    |> validate_required([:name, :asset, :amount, :address])
  end
end

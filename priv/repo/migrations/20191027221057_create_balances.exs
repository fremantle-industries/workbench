defmodule Monitor.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add(:timestamp, :utc_datetime, null: false)
      add(:usd, :decimal, null: false)
      add(:btcusd_price, :decimal, null: false)

      timestamps()
    end
  end
end

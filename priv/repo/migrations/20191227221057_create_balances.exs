defmodule Workbench.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add(:start_time, :utc_datetime, null: false)
      add(:finish_time, :utc_datetime, null: false)
      add(:usd, :decimal, null: false)
      add(:btc_usd_venue, :string, null: false)
      add(:btc_usd_symbol, :string, null: false)
      add(:btc_usd_price, :decimal, null: false)
      add(:usd_quote_venue, :string, null: false)
      add(:usd_quote_asset, :string, null: false)

      timestamps()
    end

    create table(:wallets) do
      add(:name, :string, null: false)
      add(:asset, :string, null: false)
      add(:amount, :decimal, null: false)
      add(:address, :string, null: false)

      timestamps()
    end

    create(unique_index(:wallets, [:name, :asset]))
  end
end

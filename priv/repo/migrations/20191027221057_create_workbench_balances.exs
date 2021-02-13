defmodule Workbench.Repo.Migrations.CreateWorkbenchBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add(:usd, :decimal, null: false)
      add(:start_time, :utc_datetime, null: false)
      add(:finish_time, :utc_datetime, null: false)
      add(:btc_usd_venue, :string, null: false)
      add(:btc_usd_symbol, :string, null: false)
      add(:btc_usd_price, :decimal, null: false)
      add(:usd_quote_venue, :string, null: false)
      add(:usd_quote_asset, :string, null: false)

      timestamps()
    end
  end
end

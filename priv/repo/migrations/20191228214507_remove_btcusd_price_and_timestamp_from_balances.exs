defmodule Monitor.Repo.Migrations.RemoveBtcusdPriceAndTimestampFromBalances do
  use Ecto.Migration

  def up do
    alter table(:balances) do
      remove(:timestamp)
      remove(:btcusd_price)

      modify(:start_time, :utc_datetime, null: false)
      modify(:finish_time, :utc_datetime, null: false)
      modify(:btc_usd_venue, :string, null: false)
      modify(:btc_usd_symbol, :string, null: false)
      modify(:btc_usd_price, :decimal, null: false)
      modify(:usd_quote_venue, :string, null: false)
      modify(:usd_quote_asset, :string, null: false)
    end
  end

  def down do
    alter table(:balances) do
      add(:timestamp, :utc_datetime)
      add(:btcusd_price, :decimal)

      modify(:start_time, :utc_datetime, null: true)
      modify(:finish_time, :utc_datetime, null: true)
      modify(:btc_usd_venue, :string, null: true)
      modify(:btc_usd_symbol, :string, null: true)
      modify(:btc_usd_price, :decimal, null: true)
      modify(:usd_quote_venue, :string, null: true)
      modify(:usd_quote_asset, :string, null: true)
    end

    execute("""
      UPDATE balances
      SET timestamp = balances.finish_time,
          btcusd_price = balances.btc_usd_price;
    """)

    alter table(:balances) do
      modify(:timestamp, :utc_datetime, null: false)
      modify(:btcusd_price, :decimal, null: false)
    end
  end
end

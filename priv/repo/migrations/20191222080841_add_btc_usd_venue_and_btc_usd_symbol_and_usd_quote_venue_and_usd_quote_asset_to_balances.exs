defmodule Monitor.Repo.Migrations.AddBtcUsdVenueAndBtcUsdSymbolAndUsdQuoteVenueAndUsdQuoteSymbolToBalances do
  use Ecto.Migration

  def up do
    alter table(:balances) do
      add(:start_time, :utc_datetime)
      add(:finish_time, :utc_datetime)
      add(:btc_usd_venue, :string)
      add(:btc_usd_symbol, :string)
      add(:btc_usd_price, :decimal)
      add(:usd_quote_venue, :string)
      add(:usd_quote_asset, :string)
    end

    execute("""
      UPDATE balances
      SET start_time = balances.timestamp,
          finish_time = balances.timestamp,
          btc_usd_venue = 'gdax',
          btc_usd_symbol = 'btc_usd',
          btc_usd_price = balances.btcusd_price,
          usd_quote_venue = 'binance',
          usd_quote_asset = 'usdt';
    """)
  end

  def down do
    alter table(:balances) do
      remove(:start_time)
      remove(:finish_time)
      remove(:btc_usd_venue)
      remove(:btc_usd_symbol)
      remove(:btc_usd_price)
      remove(:usd_quote_venue)
      remove(:usd_quote_asset)
    end
  end
end

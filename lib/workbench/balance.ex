defmodule Workbench.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balances" do
    field(:start_time, :utc_datetime)
    field(:finish_time, :utc_datetime)
    field(:usd, :decimal)
    field(:btc_usd_venue, :string)
    field(:btc_usd_symbol, :string)
    field(:btc_usd_price, :decimal)
    field(:usd_quote_venue, :string)
    field(:usd_quote_asset, :string)

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [
      :start_time,
      :finish_time,
      :usd,
      :btc_usd_venue,
      :btc_usd_symbol,
      :btc_usd_price,
      :usd_quote_venue,
      :usd_quote_asset
    ])
    |> validate_required([
      :start_time,
      :finish_time,
      :usd,
      :btc_usd_venue,
      :btc_usd_symbol,
      :btc_usd_price,
      :usd_quote_venue,
      :usd_quote_asset
    ])
  end
end

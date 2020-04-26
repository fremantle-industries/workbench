defmodule Workbench.BalanceSnapshots.Config do
  defstruct ~w(
    enabled
    boot_delay_ms
    every_ms
    btc_usd_venue
    btc_usd_symbol
    usd_quote_venue
    usd_quote_asset
    quote_pairs
  )a
  use Vex.Struct
  alias __MODULE__

  @type venue_id :: Tai.Venues.Adapter.venue_id()
  @type product_symbol :: Tai.Venues.Product.symbol()
  @type asset :: Tai.Venues.Account.asset()
  @type quote_pair :: {venue_id, asset}
  @type t :: %Config{
          enabled: boolean,
          boot_delay_ms: non_neg_integer(),
          every_ms: non_neg_integer,
          btc_usd_venue: venue_id,
          btc_usd_symbol: product_symbol,
          usd_quote_venue: venue_id,
          usd_quote_asset: atom,
          quote_pairs: [quote_pair]
        }

  validates(:enabled, inclusion: [true, false])
  validates(:btc_usd_venue, presence: true)
  validates(:btc_usd_symbol, presence: true)
  validates(:usd_quote_venue, presence: true)
  validates(:usd_quote_asset, presence: true)
  validates(:quote_pairs, presence: true)

  @default_boot_delay_ms 60_000
  @default_every_ms 60_000

  # TODO: Use Workbench.Config here
  def parse(env \\ Application.get_env(:workbench, :balance_snapshot)) do
    config = %Config{
      enabled: Map.get(env, :enabled),
      boot_delay_ms: Map.get(env, :boot_delay_ms, @default_boot_delay_ms),
      every_ms: Map.get(env, :every_ms, @default_every_ms),
      btc_usd_venue: Map.get(env, :btc_usd_venue),
      btc_usd_symbol: Map.get(env, :btc_usd_symbol),
      usd_quote_venue: Map.get(env, :usd_quote_venue),
      usd_quote_asset: Map.get(env, :usd_quote_asset),
      quote_pairs: Map.get(env, :quote_pairs, [])
    }

    if Vex.valid?(config) do
      {:ok, config}
    else
      errors = Vex.errors(config)
      {:error, errors}
    end
  end
end

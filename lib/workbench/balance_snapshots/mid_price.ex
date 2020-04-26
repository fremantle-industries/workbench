defmodule Workbench.BalanceSnapshots.MidPrice do
  @type venue :: Tai.Venues.Adapter.venue_id()
  @type asset :: Tai.Venues.Account.asset()
  @type quote_pair :: {venue, usd_quote_asset :: asset}
  @type error_reasons ::
          {quote_pair, :not_found | :no_inside_bid | :no_inside_ask | :no_inside_bid_or_ask}

  @spec first(asset, [quote_pair]) :: {:ok, Decimal.t()} | {:error, error_reasons}
  def first(asset, quote_pairs) do
    first(asset, quote_pairs, [])
  end

  def first(_asset, [], errors) do
    {:error, errors}
  end

  def first(asset, [{venue, usd_quote_asset} | quote_pairs], errors) do
    pricing_symbol = :"#{asset}_#{usd_quote_asset}"

    with {:ok, market_quote} <- Tai.Markets.QuoteStore.find({venue, pricing_symbol}),
         {:ok, mid_price} <- Tai.Markets.Quote.mid_price(market_quote) do
      {:ok, mid_price}
    else
      {:error, reason} ->
        first(asset, quote_pairs, errors ++ [{venue, pricing_symbol, reason}])
    end
  end
end

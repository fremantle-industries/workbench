defmodule Workbench.BalanceSnapshots.MidPrice do
  @type venue :: Tai.Venues.Adapter.venue_id()
  @type product_symbol :: Tai.Venues.Product.symbol()
  @type error_reasons ::
          :not_found | :no_inside_bid | :no_inside_ask | :no_inside_bid_or_ask

  @spec fetch(venue, product_symbol) :: {:ok, Decimal.t()} | {:error, error_reasons}
  def fetch(venue, product_symbol) do
    with {:ok, market_quote} <- Tai.Markets.QuoteStore.find({venue, product_symbol}) do
      Tai.Markets.Quote.mid_price(market_quote)
    end
  end
end

defmodule TestSupport.Quotes do
  alias Tai.Markets.{PricePoint, Quote}

  def build_quote(
        venue: venue,
        symbol: symbol,
        bid: {bid_price, bid_size},
        ask: {ask_price, ask_size}
      ) do
    inside_bid = struct(PricePoint, price: bid_price, size: bid_size)
    inside_ask = struct(PricePoint, price: ask_price, size: ask_size)

    struct(
      Quote,
      venue_id: venue,
      product_symbol: symbol,
      bids: [inside_bid],
      asks: [inside_ask]
    )
  end

  def build_quote(venue: venue, symbol: symbol) do
    struct(Quote, venue_id: venue, product_symbol: symbol, bids: [], asks: [])
  end
end

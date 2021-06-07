defmodule Workbench.BalanceSnapshots.MidPriceTest do
  use Workbench.DataCase, async: false
  import TestSupport.Quotes
  alias Workbench.BalanceSnapshots

  test "returns the mid price for the first pair with a quote" do
    market_quote = build_quote(venue: :venue_b, symbol: :btc_usdt, bid: {9005, 1}, ask: {9006, 2})
    {:ok, _} = Tai.Markets.QuoteStore.put(market_quote)
    quote_pairs = [venue_a: :usdt, venue_b: :usdt]

    assert {:ok, mid_price} = BalanceSnapshots.MidPrice.first(:btc, quote_pairs)
    assert mid_price == Decimal.new("9005.5")
  end

  test "returns an error with the reason for each pair when there is no market quote or mid price" do
    market_quote = build_quote(venue: :venue_a, symbol: :btc_usdt)
    {:ok, _} = Tai.Markets.QuoteStore.put(market_quote)
    quote_pairs = [venue_a: :usdt, venue_b: :usdt]

    assert {:error, reasons} = BalanceSnapshots.MidPrice.first(:btc, quote_pairs)
    assert Enum.count(reasons) == 2
    assert Enum.at(reasons, 0) == {:venue_a, :btc_usdt, :no_inside_bid_or_ask}
    assert Enum.at(reasons, 1) == {:venue_b, :btc_usdt, :not_found}
  end
end

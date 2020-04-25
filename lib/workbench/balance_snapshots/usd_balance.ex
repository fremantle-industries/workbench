defmodule Workbench.BalanceSnapshots.UsdBalance do
  alias Workbench.BalanceSnapshots

  @type resource :: struct
  @type resources :: [resource]
  @type venue_id :: Tai.Venues.Adapter.venue_id()
  @type product_symbol :: Tai.Venues.Product.symbol()
  @type market_quote_not_found_error ::
          {:market_quote_not_found, pricing_symbol :: product_symbol, amount :: Decimal.t()}
  @type error_reasons :: [market_quote_not_found_error]

  @spec fetch(resources, venue_id) :: {:ok, Decimal.t()} | {:error, error_reasons}
  def fetch(resources, usd_quote_venue) do
    resources
    |> Enum.map(fn {pricing_symbol, amount, resource} ->
      with {:ok, mid_price} <- BalanceSnapshots.MidPrice.fetch(usd_quote_venue, pricing_symbol) do
        usd_balance = Decimal.mult(amount, mid_price)
        {:ok, usd_balance, resource}
      else
        {:error, :not_found} ->
          {:error, :market_quote_not_found, pricing_symbol}

        {:error, reason} ->
          {:error, reason, pricing_symbol}
      end
    end)
    |> Enum.reduce(
      {:ok, Decimal.new(0)},
      fn
        {:ok, usd_balance, _}, {:ok, acc_balance} ->
          {:ok, Decimal.add(usd_balance, acc_balance)}

        {:ok, _, _}, error = {:error, _} ->
          error

        {:error, reason, pricing_symbol}, {:ok, _} ->
          {:error, [{reason, pricing_symbol}]}

        {:error, reason, pricing_symbol}, {:error, reasons} ->
          {:error, [{reason, pricing_symbol} | reasons]}
      end
    )
  end
end

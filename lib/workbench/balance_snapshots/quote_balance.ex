defmodule Workbench.BalanceSnapshots.QuoteBalance do
  alias Workbench.BalanceSnapshots

  @type venue_id :: Tai.Venue.id()
  @type asset :: Tai.Venues.Account.asset()
  @type amount :: Decimal.t()
  @type record :: {quote_venue :: venue_id, quote_asset :: asset, asset, amount}

  @spec fetch([record]) :: {:ok, Decimal.t()} | {:error, [term]}
  def fetch(records) do
    records
    |> Enum.map(&calc_balance/1)
    |> Enum.reduce(
      {:ok, Decimal.new(0)},
      fn
        {:ok, balance}, {:ok, acc_balance} ->
          {:ok, Decimal.add(balance, acc_balance)}

        {:ok, _}, {:error, _reasons} = error ->
          error

        {:error, _reasons} = error, {:ok, _} ->
          error

        {:error, new_reasons}, {:error, existing_reasons} ->
          {:error, existing_reasons ++ new_reasons}
      end
    )
  end

  defp calc_balance({
         [{_, quote_asset} | _],
         asset,
         amount
       })
       when quote_asset == asset do
    {:ok, amount}
  end

  defp calc_balance({quote_pairs, asset, amount}) do
    with {:ok, mid_price} <- BalanceSnapshots.MidPrice.first(asset, quote_pairs) do
      balance = Decimal.mult(amount, mid_price)
      {:ok, balance}
    else
      {:error, _reasons} = error ->
        error
    end
  end
end

defmodule WorkbenchWeb.BalanceView do
  use WorkbenchWeb, :view

  def finish_times(balances) do
    balances
    |> Enum.map(& &1.finish_time)
    |> Enum.map(&format_timestamp/1)
  end

  def usd_balances(balances) do
    balances
    |> Enum.map(& &1.usd)
    |> Enum.map(&Decimal.to_float/1)
  end

  def btc_balances(balances) do
    balances
    |> Enum.map(&Decimal.div(&1.usd, &1.btc_usd_price))
    |> Enum.map(&Decimal.to_float/1)
  end

  def btc_usd_prices(balances) do
    balances
    |> Enum.map(& &1.btc_usd_price)
    |> Enum.map(&Decimal.to_float/1)
  end

  @timestamp_format "{YYYY}-{0M}-{0D} {h12}:{m} {s}"
  def format_timestamp(timestamp) do
    timestamp
    |> Timex.format!(@timestamp_format)
  end
end

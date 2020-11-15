defmodule Workbench.BalanceSnapshots.QuoteBalanceTest do
  use ExUnit.Case, async: false
  import TestSupport.Quotes
  alias Workbench.BalanceSnapshots

  setup do
    on_exit(fn ->
      :ok = Application.stop(:tai)
      {:ok, _} = Application.ensure_all_started(:tai)
    end)

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Workbench.Repo)

    :ok
  end

  test "calculates the usd value of the assets" do
    btc_usd_quote = build_quote(venue: :venue_b, symbol: :btc_usd, bid: {9000, 1}, ask: {9001, 2})
    ltc_usd_quote = build_quote(venue: :venue_b, symbol: :ltc_usd, bid: {40, 1}, ask: {41, 2})
    {:ok, _} = Tai.Markets.QuoteStore.put(btc_usd_quote)
    {:ok, _} = Tai.Markets.QuoteStore.put(ltc_usd_quote)
    {:ok, btc} = create_wallet(name: "venue_b", asset: "btc", amount: 1)
    {:ok, ltc} = create_wallet(name: "venue_b", asset: "ltc", amount: 200)

    records = [
      {[venue_a: :usd, venue_b: :usd], :btc, btc.amount},
      {[venue_b: :usd], :ltc, ltc.amount}
    ]

    assert {:ok, usd_balance} = BalanceSnapshots.QuoteBalance.fetch(records)
    assert usd_balance == Decimal.new("17100.5")
  end

  test "uses the amount directly when the asset is used for quotes" do
    {:ok, usdt} = create_wallet(name: "venue_b", asset: "usdt", amount: 10)

    records = [
      {[venue_a: :usdt, venue_b: :usdt], :usdt, usdt.amount}
    ]

    assert {:ok, usd_balance} = BalanceSnapshots.QuoteBalance.fetch(records)
    assert usd_balance == Decimal.new(10)
  end

  test "bubbles errors when no records have a quote" do
    {:ok, btc} = create_wallet(name: "venue_b", asset: "btc", amount: 1)
    {:ok, ltc} = create_wallet(name: "venue_b", asset: "ltc", amount: 10)

    records = [
      {[venue_b: :usd], :btc, btc.amount},
      {[venue_a: :usd, venue_b: :usd], :ltc, ltc.amount}
    ]

    assert {:error, reasons} = BalanceSnapshots.QuoteBalance.fetch(records)
    assert Enum.count(reasons) == 3
    assert Enum.at(reasons, 0) == {:venue_b, :btc_usd, :not_found}
    assert Enum.at(reasons, 1) == {:venue_a, :ltc_usd, :not_found}
    assert Enum.at(reasons, 2) == {:venue_b, :ltc_usd, :not_found}
  end

  test "bubbles errors when there is a mixture of records with quotes and no quotes" do
    btc_usd_quote = build_quote(venue: :venue_b, symbol: :btc_usd, bid: {9000, 1}, ask: {9001, 2})
    {:ok, _} = Tai.Markets.QuoteStore.put(btc_usd_quote)
    {:ok, eth} = create_wallet(name: "venue_a", asset: "eth", amount: 5)
    {:ok, btc} = create_wallet(name: "venue_b", asset: "btc", amount: 1)

    records = [
      {[venue_a: :usd], :eth, eth.amount},
      {[venue_b: :usd], :btc, btc.amount}
    ]

    assert {:error, reasons} = BalanceSnapshots.QuoteBalance.fetch(records)
    assert Enum.count(reasons) == 1
    assert Enum.at(reasons, 0) == {:venue_a, :eth_usd, :not_found}
  end

  defp create_wallet(name: name, asset: asset, amount: amount) do
    %Workbench.Wallet{}
    |> Workbench.Wallet.changeset(%{
      name: name,
      asset: asset,
      amount: Tai.Utils.Decimal.cast!(amount),
      address: "-"
    })
    |> Workbench.Repo.insert()
  end
end

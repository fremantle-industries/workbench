defmodule Workbench.BalanceSnapshots.SnapshotTest do
  use Workbench.DataCase, async: false
  import TestSupport.Quotes
  alias Workbench.BalanceSnapshots

  @venue :venue_a
  @product :btc_usdt
  @usd_quote_asset :usdt
  @config struct(BalanceSnapshots.Config,
            btc_usd_venue: @venue,
            btc_usd_symbol: @product,
            usd_quote_venue: @venue,
            usd_quote_asset: @usd_quote_asset,
            quote_pairs: [{@venue, @usd_quote_asset}]
          )

  test "creates a balance snapshot with the value of wallets & accounts in the quote pair asset" do
    btc_usdt_quote =
      build_quote(
        venue: @venue,
        symbol: :btc_usdt,
        bid: {10_000, 1},
        ask: {10_001, 2}
      )

    ltc_usdt_quote =
      build_quote(
        venue: @venue,
        symbol: :ltc_usdt,
        bid: {50, 1},
        ask: {51, 2}
      )

    {:ok, _} = Tai.Markets.QuoteStore.put(btc_usdt_quote)
    {:ok, _} = Tai.Markets.QuoteStore.put(ltc_usdt_quote)

    create_wallet(name: "venue_a", asset: "usdt", amount: 10)
    create_wallet(name: "venue_b", asset: "btc", amount: 1)
    create_wallet(name: "venue_b", asset: "ltc", amount: 200)

    create_account(venue: :venue_a, credential: :main, asset: :btc, free: 1, locked: 0.1)
    create_account(venue: :venue_a, credential: :main, asset: :ltc, free: 2, locked: 0.2)
    create_account(venue: :venue_b, credential: :main, asset: :usdt, free: 100, locked: 0)

    assert {:ok, balance} = BalanceSnapshots.Snapshot.create(@config)
    assert %Workbench.Balance{} = balance
    assert Ecto.get_meta(balance, :state) == :loaded

    assert %DateTime{} = balance.start_time
    assert %DateTime{} = balance.finish_time
    assert balance.btc_usd_venue == "venue_a"
    assert balance.btc_usd_symbol == "btc_usdt"
    assert balance.btc_usd_price == Decimal.new("10000.5")
    assert balance.usd_quote_venue == "venue_a"
    assert balance.usd_quote_asset == "usdt"
    assert balance.usd == Decimal.new("31322.15")
  end

  test "bubbles errors" do
    no_mid_price_config =
      struct(BalanceSnapshots.Config,
        btc_usd_venue: :venue_b,
        btc_usd_symbol: @product,
        quote_pairs: [venue_b: @usd_quote_asset]
      )

    assert BalanceSnapshots.Snapshot.create(no_mid_price_config) ==
             {:error, [{:venue_b, :btc_usdt, :not_found}]}
  end

  defp create_wallet(name: name, asset: asset, amount: amount) do
    {:ok, _} =
      %Workbench.Wallet{}
      |> Workbench.Wallet.changeset(%{
        name: name,
        asset: asset,
        amount: Tai.Utils.Decimal.cast!(amount),
        address: "-"
      })
      |> Workbench.Repo.insert()
  end

  defp create_account(
         venue: venue,
         credential: credential,
         asset: asset,
         free: free,
         locked: locked
       ) do
    {:ok, free} = Decimal.cast(free)
    {:ok, locked} = Decimal.cast(locked)
    equity = Decimal.add(free, locked)

    {:ok, _} =
      Tai.Venues.Account
      |> struct(
        venue_id: venue,
        credential_id: credential,
        asset: asset,
        equity: equity,
        free: free,
        locked: locked
      )
      |> Tai.Venues.AccountStore.put()
  end
end

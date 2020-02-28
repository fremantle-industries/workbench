defmodule BackOffice.BalanceSnapshots.SnapshotTest do
  use ExUnit.Case, async: false
  alias BackOffice.BalanceSnapshots

  @venue :venue_a
  @product :btc_usd
  @usd_quote_asset :usd
  @config struct(BalanceSnapshots.Config,
            btc_usd_venue: @venue,
            btc_usd_symbol: @product,
            usd_quote_venue: @venue,
            usd_quote_asset: @usd_quote_asset
          )
  @btc_usd_inside_bid struct(Tai.Markets.PricePoint, price: 10_000, size: 1)
  @btc_usd_inside_ask struct(Tai.Markets.PricePoint, price: 10_001, size: 2)
  @btc_usd_market_quote struct(Tai.Markets.Quote,
                          venue_id: @venue,
                          product_symbol: @product,
                          bids: [@btc_usd_inside_bid],
                          asks: [@btc_usd_inside_ask]
                        )
  @ltc_usd_inside_bid struct(Tai.Markets.PricePoint, price: 50, size: 1)
  @ltc_usd_inside_ask struct(Tai.Markets.PricePoint, price: 51, size: 2)
  @ltc_usd_market_quote struct(Tai.Markets.Quote,
                          venue_id: @venue,
                          product_symbol: :ltc_usd,
                          bids: [@ltc_usd_inside_bid],
                          asks: [@ltc_usd_inside_ask]
                        )

  setup do
    on_exit(fn ->
      :ok = Application.stop(:tai)
      {:ok, _} = Application.ensure_all_started(:tai)
    end)

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BackOffice.Repo)
    {:ok, _} = Tai.Markets.QuoteStore.put(@btc_usd_market_quote)
    {:ok, _} = Tai.Markets.QuoteStore.put(@ltc_usd_market_quote)

    :ok
  end

  test "creates a balance snapshot with the USD value of wallets, assets, current btc_usd price, venue and symbol" do
    create_wallet(name: "venue_b", asset: "btc", amount: Decimal.new(1))
    create_wallet(name: "venue_b", asset: "ltc", amount: Decimal.new(200))

    create_account(
      venue: :venue_a,
      credential: :main,
      asset: :btc,
      free: Decimal.new(1),
      locked: Decimal.new("0.1")
    )

    create_account(
      venue: :venue_a,
      credential: :main,
      asset: :ltc,
      free: Decimal.new(2),
      locked: Decimal.new("0.2")
    )

    assert {:ok, balance} = BalanceSnapshots.Snapshot.create(@config)
    assert %BackOffice.Balance{} = balance
    assert Ecto.get_meta(balance, :state) == :loaded

    assert %DateTime{} = balance.start_time
    assert %DateTime{} = balance.finish_time
    assert balance.btc_usd_venue == "venue_a"
    assert balance.btc_usd_symbol == "btc_usd"
    assert balance.btc_usd_price == Decimal.new("10000.5")
    assert balance.usd_quote_venue == "venue_a"
    assert balance.usd_quote_asset == "usd"
    assert balance.usd == Decimal.new("31212.15")
  end

  test "bubbles errors" do
    no_mid_price_config =
      struct(BalanceSnapshots.Config, btc_usd_venue: :venue_b, btc_usd_symbol: @product)

    assert BalanceSnapshots.Snapshot.create(no_mid_price_config) == {:error, :not_found}
  end

  defp create_wallet(name: name, asset: asset, amount: amount) do
    {:ok, _} =
      %BackOffice.Wallet{}
      |> BackOffice.Wallet.changeset(%{
        name: name,
        asset: asset,
        amount: Decimal.cast(amount),
        address: "-"
      })
      |> BackOffice.Repo.insert()
  end

  defp create_account(
         venue: venue,
         credential: credential,
         asset: asset,
         free: free,
         locked: locked
       ) do
    free = Decimal.cast(free)
    locked = Decimal.cast(locked)
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

defmodule BackOffice.BalanceSnapshots.UsdBalanceTest do
  use ExUnit.Case, async: false
  alias BackOffice.BalanceSnapshots

  @eth_usd_inside_bid struct(Tai.Markets.PricePoint, price: 100, size: 1)
  @eth_usd_inside_ask struct(Tai.Markets.PricePoint, price: 101, size: 2)
  @eth_usd_market_quote struct(Tai.Markets.Quote,
                          venue_id: :venue_b,
                          product_symbol: :eth_usd,
                          bids: [@eth_usd_inside_bid],
                          asks: [@eth_usd_inside_ask]
                        )

  setup do
    on_exit(fn ->
      :ok = Application.stop(:tai)
      {:ok, _} = Application.ensure_all_started(:tai)
    end)

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BackOffice.Repo)
    {:ok, _} = Tai.Markets.QuoteStore.put(@eth_usd_market_quote)

    :ok
  end

  test "returns an error when there are no market quotes for the wallet asset" do
    {:ok, btc} =
      %BackOffice.Wallet{}
      |> BackOffice.Wallet.changeset(%{
        name: "venue_b",
        asset: "btc",
        amount: Decimal.new(1),
        address: "bc1abc"
      })
      |> BackOffice.Repo.insert()

    {:ok, ltc} =
      %BackOffice.Wallet{}
      |> BackOffice.Wallet.changeset(%{
        name: "venue_b",
        asset: "ltc",
        amount: Decimal.new(200),
        address: "lc1abc"
      })
      |> BackOffice.Repo.insert()

    {:ok, eth} =
      %BackOffice.Wallet{}
      |> BackOffice.Wallet.changeset(%{
        name: "venue_b",
        asset: "eth",
        amount: Decimal.new(30),
        address: "eth1abc"
      })
      |> BackOffice.Repo.insert()

    resources = [
      {:btc_usd, btc.amount, btc},
      {:ltc_usd, ltc.amount, ltc},
      {:eth_usd, eth.amount, eth}
    ]

    assert {:error, reasons} = BalanceSnapshots.UsdBalance.fetch(resources, :venue_b)
    assert Enum.count(reasons) == 2
    assert {:market_quote_not_found, _} = Enum.at(reasons, 0)
    assert {:market_quote_not_found, _} = Enum.at(reasons, 1)
  end

  test "passes through other errors" do
    btc_usd_market_quote =
      struct(Tai.Markets.Quote,
        venue_id: :venue_b,
        product_symbol: :btc_usd,
        bids: [],
        asks: []
      )

    {:ok, _} = Tai.Markets.QuoteStore.put(btc_usd_market_quote)

    {:ok, btc} =
      %BackOffice.Wallet{}
      |> BackOffice.Wallet.changeset(%{
        name: "venue_b",
        asset: "btc",
        amount: Decimal.new(1),
        address: "bc1abc"
      })
      |> BackOffice.Repo.insert()

    resources = [
      {:btc_usd, btc.amount, btc}
    ]

    assert {:error, reasons} = BalanceSnapshots.UsdBalance.fetch(resources, :venue_b)
    assert Enum.count(reasons) == 1
    assert {:no_inside_bid_or_ask, _} = Enum.at(reasons, 0)
  end
end

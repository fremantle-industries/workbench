defmodule Workbench.BalanceSnapshots.Snapshot do
  require Ecto.Query
  alias Workbench.BalanceSnapshots

  @type config :: BalanceSnapshots.Config.t()
  @type balance :: term
  @type mid_price_error_reasons :: BalanceSnapshots.MidPrice.error_reasons()

  @spec create(config) :: {:ok, balance} | {:error, mid_price_error_reasons}
  def create(config) do
    start_time = Timex.now()

    with {:ok, btc_usd_price} <-
           BalanceSnapshots.MidPrice.fetch(config.btc_usd_venue, config.btc_usd_symbol),
         {:ok, wallets_usd_balance} <-
           config.usd_quote_asset
           |> wallet_resources()
           |> BalanceSnapshots.UsdBalance.fetch(config.usd_quote_venue),
         {:ok, assets_usd_balance} <-
           config.usd_quote_asset
           |> account_resources()
           |> BalanceSnapshots.UsdBalance.fetch(config.usd_quote_venue) do
      usd_balance = Decimal.add(wallets_usd_balance, assets_usd_balance)

      %Workbench.Balance{}
      |> Workbench.Balance.changeset(%{
        start_time: start_time,
        finish_time: Timex.now(),
        timestamp: Timex.now(),
        usd: usd_balance,
        btc_usd_venue: config |> config_to_string(:btc_usd_venue),
        btc_usd_symbol: config |> config_to_string(:btc_usd_symbol),
        btc_usd_price: btc_usd_price,
        usd_quote_venue: config |> config_to_string(:usd_quote_venue),
        usd_quote_asset: config |> config_to_string(:usd_quote_asset)
      })
      |> Workbench.Repo.insert()
    end
  end

  defp wallet_resources(usd_quote_asset) do
    Ecto.Query.from(
      b in "wallets",
      select: [:id, :name, :asset, :amount]
    )
    |> Workbench.Repo.all()
    |> Enum.map(fn w ->
      {
        build_pricing_symbol(w.asset, usd_quote_asset),
        w.amount,
        w
      }
    end)
  end

  defp account_resources(usd_quote_asset) do
    Tai.Venues.AccountStore.all()
    |> Enum.map(fn a ->
      {
        build_pricing_symbol(a.asset, usd_quote_asset),
        a.equity,
        a
      }
    end)
  end

  defp build_pricing_symbol(asset, usd_quote_asset), do: :"#{asset}_#{usd_quote_asset}"

  defp config_to_string(config, attr), do: config |> Map.fetch!(attr) |> Atom.to_string()
end

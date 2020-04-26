defmodule Workbench.BalanceSnapshots.Snapshot do
  require Ecto.Query
  alias Workbench.BalanceSnapshots

  @type config :: BalanceSnapshots.Config.t()
  @type balance :: term
  @type mid_price_error_reasons :: BalanceSnapshots.MidPrice.error_reasons()

  @spec create(config) :: {:ok, balance} | {:error, mid_price_error_reasons}
  def create(config) do
    wallets = wallet_resources(config)
    accounts = account_resources(config)
    start_time = Timex.now()

    with {:ok, btc_usd_price} <- BalanceSnapshots.MidPrice.first(:btc, config.quote_pairs),
         {:ok, wallets_usd_balance} <- BalanceSnapshots.QuoteBalance.fetch(wallets),
         {:ok, assets_usd_balance} <- BalanceSnapshots.QuoteBalance.fetch(accounts) do
      usd_balance = Decimal.add(wallets_usd_balance, assets_usd_balance)

      %Workbench.Balance{}
      |> Workbench.Balance.changeset(%{
        start_time: start_time,
        finish_time: Timex.now(),
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

  defp wallet_resources(config) do
    Ecto.Query.from(
      b in "wallets",
      select: [:id, :name, :asset, :amount]
    )
    |> Workbench.Repo.all()
    |> Enum.map(fn w ->
      {config.quote_pairs, String.to_atom(w.asset), w.amount}
    end)
  end

  defp account_resources(config) do
    Tai.Venues.AccountStore.all()
    |> Enum.map(fn a ->
      {config.quote_pairs, a.asset, a.equity}
    end)
  end

  defp config_to_string(config, attr), do: config |> Map.fetch!(attr) |> Atom.to_string()
end

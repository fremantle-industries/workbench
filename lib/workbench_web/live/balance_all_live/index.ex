defmodule WorkbenchWeb.BalanceAllLive.Index do
  use WorkbenchWeb, :live_view
  require Ecto.Query

  defmodule QueryParams do
    defstruct ~w(size)a

    @default_size 720

    def new(params) do
      %QueryParams{
        size: int_param(params, ["size"], @default_size)
      }
    end

    defp int_param(params, keys, default) do
      param = get_in(params, keys) || ""

      param
      |> Integer.parse()
      |> case do
        {val, _} -> val
        :error -> default
      end
    end
  end

  def mount(_params, _session, socket) do
    Workbench.Schoolbus.subscribe(:balance_snapshot)
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    query_params = QueryParams.new(params)

    socket =
      socket
      |> assign(:size, query_params.size)
      |> assign(:balances, balances(size: query_params.size))

    {:noreply, socket}
  end

  def handle_info({:balance_snapshot, :new_balance, _balance}, socket) do
    socket =
      socket
      |> assign(:balances, balances(size: socket.assigns.size))

    {:noreply, socket}
  end

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

  defp balances(size: size) do
    Ecto.Query.from(
      b in "balances",
      order_by: [desc: :finish_time],
      limit: ^size,
      select: [
        :id,
        :finish_time,
        :usd,
        :btc_usd_price
      ]
    )
    |> Workbench.Repo.all()
    |> Enum.reverse()
  end
end

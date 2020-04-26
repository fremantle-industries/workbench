defmodule WorkbenchWeb.BalanceDayLive.Index do
  use WorkbenchWeb, :live_view
  require Ecto.Query

  defmodule QueryParams do
    defstruct ~w(size)a

    @default_size 90

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
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    query_params = QueryParams.new(params)

    socket =
      socket
      |> assign(:balances, balances(size: query_params.size))

    {:noreply, socket}
  end

  def days(balances) do
    balances
    |> Enum.map(& &1.time)
    |> Enum.map(&format_timestamp/1)
  end

  def usd_min(balances) do
    balances
    |> Enum.map(& &1.min)
    |> Enum.map(&Decimal.to_float/1)
  end

  def usd_max(balances) do
    balances
    |> Enum.map(& &1.max)
    |> Enum.map(&Decimal.to_float/1)
  end

  @timestamp_format "{YYYY}-{0M}-{0D} {h12}:{m} {s}"
  def format_timestamp(timestamp) do
    timestamp
    |> Timex.format!(@timestamp_format)
  end

  defp balances(size: size) do
    Ecto.Query.from(
      b in Workbench.Balance,
      select: %{
        time: fragment("DATE_TRUNC('day', ?) AS time", b.finish_time),
        min: min(b.usd),
        max: max(b.usd)
      },
      group_by: [fragment("time")],
      order_by: [desc: fragment("time")],
      limit: ^size
    )
    |> Workbench.Repo.all()
    |> Enum.reverse()
  end
end

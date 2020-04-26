defmodule WorkbenchWeb.BalanceTableLive.Index do
  use WorkbenchWeb, :live_view
  require Ecto.Query

  defmodule QueryParams do
    defstruct ~w(page page_size)a

    @default_page 1
    @default_page_size 20

    def new(params) do
      %QueryParams{
        page: int_param(params, ["page"], @default_page),
        page_size: int_param(params, ["page_size"], @default_page_size)
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
      |> assign(:page, query_params.page)
      |> assign(:page_size, query_params.page_size)
      |> assign(:page_count, page_count())
      |> assign(:balances, balances(page: query_params.page, page_size: query_params.page_size))

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    %Workbench.Balance{id: id |> String.to_integer()} |> Workbench.Repo.delete()
    %{page: page, page_size: page_size} = socket.assigns

    socket =
      socket
      |> assign(:page_count, page_count())
      |> assign(:balances, balances(page: page, page_size: page_size))

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

  @first_page 1
  def first_page, do: @first_page
  def previous_page(page), do: max(page - 1, @first_page)
  def next_page(page), do: page + 1
  def last_page(page_count, page_size), do: div(page_count, page_size) + @first_page

  defp page_count do
    Ecto.Query.from(
      b in Workbench.Balance,
      select: count()
    )
    |> Workbench.Repo.one()
  end

  defp balances(page: page, page_size: page_size) do
    Ecto.Query.from(
      b in "balances",
      order_by: [desc: :finish_time],
      offset: ^(max(page - 1, 0) * page_size),
      limit: ^page_size,
      select: [
        :id,
        :start_time,
        :finish_time,
        :usd,
        :btc_usd_venue,
        :btc_usd_symbol,
        :btc_usd_price,
        :usd_quote_venue,
        :usd_quote_asset
      ]
    )
    |> Workbench.Repo.all()
  end
end

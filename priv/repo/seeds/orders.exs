require Ecto.Query

alias Tai.NewOrders.{FailedOrderTransition, Order, OrderTransition, OrderRepo}

# create error order
{:ok, order_1} =
  %Order{}
  |> Order.changeset(%{
    venue: "venue_a",
    credential: "main",
    product_symbol: "btc_usd",
    venue_product_symbol: "BTC-USD",
    product_type: :spot,
    type: :limit,
    price: Decimal.new("2500.5"),
    qty: Decimal.new("2.1"),
    leaves_qty: Decimal.new(0),
    cumulative_qty: Decimal.new(0),
    side: :buy,
    status: :create_error,
    time_in_force: :gtc,
    post_only: true,
    close: false
  })
  |> OrderRepo.insert()

{:ok, _order_1_transition_1} =
  %OrderTransition{}
  |> OrderTransition.changeset(%{
    order_client_id: order_1.client_id,
    transition: %{
      error: %UndefinedFunctionError{
        arity: 0,
        function: :from,
        message: nil,
        module: Ecto.Changeset,
        reason: nil
      },
      stacktrace: [
        {Ecto.Changeset, :from, [], []},
        {Tai.NewOrders.Services.ApplyOrderTransition, :call, 1,
         [file: "lib/tai/new_orders/services/apply_order_transition.ex", line: 11]}
      ],
      __type__: :rescue_create_error
    }
  })
  |> OrderRepo.insert()

{:ok, _order_1_failed_transition_1} =
  %FailedOrderTransition{}
  |> FailedOrderTransition.changeset(%{
    order_client_id: order_1.client_id,
    type: "accept_create",
    error: %{transition: %{venue_order_id: ["can't be blank"]}}
  })
  |> OrderRepo.insert()

# filled order
{:ok, order_2} =
  %Order{}
  |> Order.changeset(%{
    venue: "venue_a",
    credential: "main",
    product_symbol: "btc_usd",
    venue_product_symbol: "BTC-USD",
    product_type: :spot,
    type: :limit,
    price: Decimal.new("2510.5"),
    qty: Decimal.new("1.12"),
    leaves_qty: Decimal.new(0),
    cumulative_qty: Decimal.new("1.12"),
    side: :buy,
    status: :filled,
    time_in_force: :gtc,
    post_only: true,
    close: false
  })
  |> OrderRepo.insert()

{:ok, _order_2_transition_1} =
  %OrderTransition{}
  |> OrderTransition.changeset(%{
    order_client_id: order_2.client_id,
    transition: %{
      venue_order_id: "abc123",
      cumulative_qty: order_2.cumulative_qty,
      last_venue_timestamp: DateTime.utc_now(),
      last_received_at: DateTime.utc_now(),
      __type__: :fill
    }
  })
  |> OrderRepo.insert()

# open order
{:ok, order_3} =
  %Order{}
  |> Order.changeset(%{
    venue: "venue_a",
    credential: "main",
    product_symbol: "btc_usd",
    venue_product_symbol: "BTC-USD",
    product_type: :spot,
    type: :limit,
    price: Decimal.new("2510.5"),
    qty: Decimal.new("1.12"),
    leaves_qty: Decimal.new("1.12"),
    cumulative_qty: Decimal.new(0),
    side: :buy,
    status: :open,
    time_in_force: :gtc,
    post_only: true,
    close: false
  })
  |> OrderRepo.insert()

{:ok, _order_3_transition_1} =
  %OrderTransition{}
  |> OrderTransition.changeset(%{
    order_client_id: order_3.client_id,
    transition: %{
      venue_order_id: "zzz999",
      cumulative_qty: order_3.cumulative_qty,
      leaves_qty: order_3.leaves_qty,
      last_venue_timestamp: DateTime.utc_now(),
      last_received_at: DateTime.utc_now(),
      __type__: :open
    }
  })
  |> OrderRepo.insert()

require Ecto.Query

alias Tai.NewOrders.{FailedOrderTransition, Order, OrderTransition, OrderRepo}

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

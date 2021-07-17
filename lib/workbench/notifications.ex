defmodule Workbench.Notifications do
  use GenServer
  alias Tai.Orders.Transitions

  @spec start_link(term) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :subscribe}}
  end

  @impl true
  def handle_continue(:subscribe, state) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "order_updated:*")
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.Fill{} = t}, state) do
    subject = "Order Filled"
    message = "#{client_id} filled #{t.cumulative_qty}"
    Notified.create(subject, message, [])

    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.PartialFill{} = t}, state) do
    subject = "Order Partially Filled"
    message = "#{client_id} partially filled #{t.cumulative_qty}"
    Notified.create(subject, message, [])

    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.VenueCreateError{} = t}, state) do
    subject = "Order Venue Create Error"
    message = "#{client_id} - #{inspect(t.reason)}"
    Notified.create(subject, message, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.RescueCreateError{} = t}, state) do
    subject = "Order Rescue Create Error"
    message = "#{client_id} - #{inspect(t.error)}\n#{inspect(t.stacktrace)}"
    Notified.create(subject, message, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.VenueCancelError{} = t}, state) do
    subject = "Order Venue Cancel Error"
    message = "#{client_id} - #{inspect(t.reason)}"
    Notified.create(subject, message, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.RescueCancelError{} = t}, state) do
    subject = "Order Rescue Cancel Error"
    message = "#{client_id} - #{inspect(t.error)}\n#{inspect(t.stacktrace)}"
    Notified.create(subject, message, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.VenueAmendError{} = t}, state) do
    subject = "Order Venue Amend Error"
    message = "#{client_id} - #{inspect(t.reason)}"
    Notified.create(subject, message, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, client_id, %Transitions.RescueAmendError{} = t}, state) do
    subject = "Order Rescue Amend Error"
    message = "#{client_id} - #{inspect(t.error)}\n#{inspect(t.stacktrace)}"
    Notified.create(subject, message, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:order_updated, _, _}, state) do
    {:noreply, state}
  end
end

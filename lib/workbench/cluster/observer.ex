defmodule Workbench.Cluster.Observer do
  use GenServer
  require Logger

  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl GenServer
  def init(state) do
    :net_kernel.monitor_nodes(true)
    {:ok, state}
  end

  @impl GenServer
  def handle_info({node_status, _node} = monitored, state) when node_status in [:nodeup, :nodedown] do
    create_notification(monitored)
    {:noreply, state}
  end

  defp create_notification({:nodeup, node}) do
    subject = "Node connected"
    message = "#{node} connected to the cluster"
    tags = ["cluster", "connect"]
    Notified.create(subject, message, tags)
  end

  defp create_notification({:nodedown, node}) do
    subject = "Node disconnected"
    message = "#{node} disconnected from the cluster"
    tags = ["cluster", "disconnect"]
    Notified.create(subject, message, tags)
  end
end

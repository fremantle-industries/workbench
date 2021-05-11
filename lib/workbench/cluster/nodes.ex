defmodule Workbench.Cluster.Nodes do
  def connect_node(node) do
    result = apply(:net_kernel, :connect_node, [node])
    create_notification(:connect, node)

    result
  end

  def disconnect_node(node) do
    result = apply(:erlang, :disconnect_node, [node])
    create_notification(:disconnect, node)

    result
  end

  def nodes(args) do
    result = apply(:erlang, :nodes, [args])
    result
  end

  defp create_notification(:connect, node) do
    subject = "Node connected"
    message = "#{node} connected to the cluster"
    tags = ["cluster", "connect"]
    Notified.create(subject, message, tags)
  end

  defp create_notification(:disconnect, node) do
    subject = "Node disconnected"
    message = "#{node} disconnected from the cluster"
    tags = ["cluster", "disconnect"]
    Notified.create(subject, message, tags)
  end
end

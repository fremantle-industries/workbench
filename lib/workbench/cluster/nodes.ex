defmodule Workbench.Cluster.Nodes do
  def connect_node(node) do
    result = apply(:net_kernel, :connect_node, [node])
    create_notification(:connect, result, node)

    result
  end

  def disconnect_node(node) do
    result = apply(:erlang, :disconnect_node, [node])
    create_notification(:disconnect, result, node)

    result
  end

  def nodes(args) do
    result = apply(:erlang, :nodes, [args])
    result
  end

  defp create_notification(:connect, true, node) do
    subject = "Node connected"
    message = "#{node} connected to the cluster"
    tags = ["cluster", "connect"]
    Notified.create(subject, message, tags)
  end

  defp create_notification(:connect, false, node) do
    subject = "Node could not connect"
    message = "#{node} could not connect to the cluster"
    tags = ["cluster", "connect_error"]
    Notified.create(subject, message, tags)
  end

  defp create_notification(:disconnect, true, node) do
    subject = "Node disconnected"
    message = "#{node} disconnected from the cluster"
    tags = ["cluster", "disconnect"]
    Notified.create(subject, message, tags)
  end

  defp create_notification(:disconnect, false, node) do
    subject = "Node could not disconnect"
    message = "#{node} could not disconnect from the cluster"
    tags = ["cluster", "disconnect_error"]
    Notified.create(subject, message, tags)
  end
end

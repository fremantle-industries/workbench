defmodule Workbench.SelectedNode do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  # TODO: This would allow each user to select a different node
  # def get(user_id) do
  #   Agent.get(__MODULE__, &Map.get(&1, user_id))
  # end
  def get do
    Agent.get(__MODULE__, & &1)
  end

  # TODO: This would allow each user to select a different node
  # def put(user_id, node) when is_bitstring(user_id) do
  #   Agent.update(__MODULE__, &Map.put(&1, user_id, node))
  # end
  def put(node) do
    Agent.update(__MODULE__, fn _ -> node end)
  end
end

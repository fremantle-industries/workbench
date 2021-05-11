defmodule Workbench.Cluster.Supervisor do
  use Supervisor

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(_) do
    children = [
      {Cluster.Supervisor, [Workbench.Config.libcluster_topologies(), []]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

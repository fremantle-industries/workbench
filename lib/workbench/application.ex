defmodule Workbench.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:workbench)
    {:ok, snapshot_config} = Workbench.BalanceSnapshots.Config.parse()

    children = [
      Workbench.Cluster.Supervisor,
      Workbench.Repo,
      Workbench.SelectedNode,
      {Phoenix.PubSub, name: Workbench.PubSub},
      {Workbench.Schoolbus, [topics: [:balance_snapshot]]},
      {Workbench.BalanceSnapshots.Scheduler, [config: snapshot_config]},
      WorkbenchWeb.Telemetry,
      WorkbenchWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Workbench.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WorkbenchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

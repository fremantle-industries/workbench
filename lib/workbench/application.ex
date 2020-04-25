defmodule Workbench.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:workbench)

    {:ok, snapshot_config} = Workbench.BalanceSnapshots.Config.parse()

    children = [
      Workbench.Repo,
      {Workbench.BalanceSnapshots.Scheduler, [config: snapshot_config]},
      WorkbenchWeb.UserStore,
      WorkbenchWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Workbench.Supervisor]

    {:ok, pid} = Supervisor.start_link(children, opts)
    {:ok, _} = start_advisors()

    {:ok, pid}
  end

  def config_change(changed, _new, removed) do
    WorkbenchWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_advisors do
    store_id = Tai.Advisors.SpecStore.default_store_id()

    {started, already_started} =
      []
      |> Tai.Advisors.Instances.where(store_id)
      |> Tai.Advisors.Instances.start()

    {:ok, {started, already_started}}
  end
end

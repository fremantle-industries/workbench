defmodule BackOffice.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:back_office)

    {:ok, snapshot_config} = BackOffice.BalanceSnapshots.Config.parse()

    children = [
      BackOffice.Repo,
      {BackOffice.BalanceSnapshots.Scheduler, [config: snapshot_config]},
      BackOfficeWeb.UserStore,
      BackOfficeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: BackOffice.Supervisor]

    {:ok, pid} = Supervisor.start_link(children, opts)
    {:ok, _} = start_advisors()

    {:ok, pid}
  end

  def config_change(changed, _new, removed) do
    BackOfficeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_advisors do
    store_id = Tai.Advisors.Store.default_store_id()

    {started, already_started} =
      []
      |> Tai.Advisors.Instances.where(store_id)
      |> Tai.Advisors.Instances.start()

    {:ok, {started, already_started}}
  end
end

defmodule WorkbenchWeb.BalanceConfigController do
  use WorkbenchWeb, :controller

  def index(conn, _params) do
    scheduler_state = Workbench.BalanceSnapshots.Scheduler.to_name() |> :sys.get_state()
    render(conn, "index.html", config: scheduler_state.config)
  end
end

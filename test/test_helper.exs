Ecto.Adapters.SQL.Sandbox.mode(Workbench.Repo, :manual)
Application.put_env(:wallaby, :base_url, WorkbenchWeb.Endpoint.url())
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start()

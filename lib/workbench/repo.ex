defmodule Workbench.Repo do
  use Ecto.Repo,
    otp_app: :workbench,
    adapter: Ecto.Adapters.Postgres
end

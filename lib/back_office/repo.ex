defmodule BackOffice.Repo do
  use Ecto.Repo,
    otp_app: :back_office,
    adapter: Ecto.Adapters.Postgres
end

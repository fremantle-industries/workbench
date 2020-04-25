defmodule WorkbenchWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :workbench,
    module: WorkbenchWeb.Guardian,
    error_handler: WorkbenchWeb.AuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

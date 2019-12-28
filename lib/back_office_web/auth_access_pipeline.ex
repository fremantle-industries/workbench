defmodule BackOfficeWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :back_office,
    module: BackOfficeWeb.Guardian,
    error_handler: BackOfficeWeb.AuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

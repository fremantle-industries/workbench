defmodule BackOfficeWeb.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """

  alias BackOfficeWeb.User
  alias Ueberauth.Auth

  def find_or_create(%Auth{provider: provider} = auth) when provider == :google do
    user = build_user(auth)
    {:ok, _} = BackOfficeWeb.UserStore.upsert(user)
    {:ok, user}
  end

  def find_or_create(_auth) do
    {:error, :unknown_provider}
  end

  defp build_user(auth) do
    %User{
      id: auth.uid,
      provider: auth.provider,
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth)
    }
  end

  defp avatar_from_auth(auth), do: auth.info.image

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end
end

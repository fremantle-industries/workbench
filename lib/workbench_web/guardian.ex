defmodule WorkbenchWeb.Guardian do
  use Guardian, otp_app: :workbench

  def subject_for_token(resource, _claims) do
    sub =
      [:id, :provider]
      |> Enum.map(&Map.fetch!(resource, &1))
      |> Enum.join("-")

    {:ok, sub}
  end

  def resource_from_claims(claims) do
    [id, provider] = claims["sub"] |> String.split("-")
    user_key = {id, provider |> String.to_atom()}

    user_key
    |> WorkbenchWeb.UserStore.find()
    |> case do
      {:ok, _resource} = found ->
        found

      {:error, :not_found} ->
        {:error, :resource_not_found}
    end
  end
end

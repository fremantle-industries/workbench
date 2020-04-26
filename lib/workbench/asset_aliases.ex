defmodule Workbench.AssetAliases do
  @type asset :: Tai.Markets.Asset.symbol()

  @spec for(asset) :: [asset]
  def for(asset, {:ok, config} \\ Workbench.Config.parse()) do
    {asset, config.asset_aliases}
    |> find()
    |> case do
      {:ok, {a, aliases}} -> [a] ++ aliases
      {:error, :not_found} -> [asset]
    end
  end

  defp find({asset, alias_index} = args) do
    alias_index
    |> Map.get(asset)
    |> case do
      nil -> find_as_member(args)
      aliases -> {:ok, {asset, aliases}}
    end
  end

  defp find_as_member({asset, alias_index}) do
    alias_index
    |> Enum.find(fn {_, aliases} ->
      Enum.member?(aliases, asset)
    end)
    |> case do
      {_k, _v} = match -> {:ok, match}
      nil -> {:error, :not_found}
    end
  end
end

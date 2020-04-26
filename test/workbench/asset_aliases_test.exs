defmodule Workbench.AssetAliasesTest do
  use ExUnit.Case, async: true

  @asset_aliases %{
    btc: [:xbt],
    usd: [:usdc, :usdt]
  }
  @config struct(Workbench.Config, asset_aliases: @asset_aliases)
  @config_result {:ok, @config}

  test ".for/2 is a list with only the when there are no matches" do
    assert Workbench.AssetAliases.for(:ltc, @config_result) == [:ltc]
  end

  test ".for/2 is the alias list + asset when asset is a match" do
    assert Workbench.AssetAliases.for(:usd, @config_result) == [:usd, :usdc, :usdt]
  end

  test ".for/2 is the alias list + asset when asset is an alias" do
    assert Workbench.AssetAliases.for(:usdt, @config_result) == [:usd, :usdc, :usdt]
  end
end

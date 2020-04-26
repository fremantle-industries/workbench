defmodule Workbench.BalanceSnapshots.ConfigTest do
  use ExUnit.Case, async: true

  @valid_config struct(Workbench.BalanceSnapshots.Config,
                  enabled: false,
                  btc_usd_venue: :mock_venue_a,
                  btc_usd_symbol: :btc_usdt,
                  usd_quote_venue: :mock_venue_a,
                  usd_quote_asset: :usdt,
                  quote_pairs: [
                    mock_venue_a: :usdt
                  ]
                )

  test "parses a snapshot config from the application environment" do
    assert {:ok, config} = Workbench.BalanceSnapshots.Config.parse()
    assert config.enabled == true
    assert config.btc_usd_venue == :mock_venue_a
    assert config.btc_usd_symbol == :btc_usdt
    assert config.usd_quote_venue == :mock_venue_a
    assert config.usd_quote_asset == :usdt
    assert config.quote_pairs == [mock_venue_a: :usdt]
  end

  test "returns an error when enabled is not present" do
    config_without_enabled = Map.delete(@valid_config, :enabled)

    assert Workbench.BalanceSnapshots.Config.parse(config_without_enabled) ==
             {:error, [{:error, :enabled, :inclusion, "must be one of [true, false]"}]}
  end

  test "returns an error when btc_usd venue is not present" do
    config_without_venue = Map.delete(@valid_config, :btc_usd_venue)

    assert Workbench.BalanceSnapshots.Config.parse(config_without_venue) ==
             {:error, [{:error, :btc_usd_venue, :presence, "must be present"}]}
  end

  test "returns an error when btc_usd symbol is not present" do
    config_without_symbol = Map.delete(@valid_config, :btc_usd_symbol)

    assert Workbench.BalanceSnapshots.Config.parse(config_without_symbol) ==
             {:error, [{:error, :btc_usd_symbol, :presence, "must be present"}]}
  end

  test "returns an error when usd_quote venue is not present" do
    config_without_venue = Map.delete(@valid_config, :usd_quote_venue)

    assert Workbench.BalanceSnapshots.Config.parse(config_without_venue) ==
             {:error, [{:error, :usd_quote_venue, :presence, "must be present"}]}
  end

  test "returns an error when usd_quote symbol is not present" do
    config_without_symbol = Map.delete(@valid_config, :usd_quote_asset)

    assert Workbench.BalanceSnapshots.Config.parse(config_without_symbol) ==
             {:error, [{:error, :usd_quote_asset, :presence, "must be present"}]}
  end

  test "returns an error when it least 1 usd quote is not present" do
    config_without_symbol = Map.delete(@valid_config, :quote_pairs)

    assert Workbench.BalanceSnapshots.Config.parse(config_without_symbol) ==
             {:error, [{:error, :quote_pairs, :presence, "must be present"}]}
  end

  test "can parse boot_delay_ms" do
    config = Map.put(@valid_config, :boot_delay_ms, 1)

    assert {:ok, config} = Workbench.BalanceSnapshots.Config.parse(config)
    assert config.boot_delay_ms == 1
  end

  test "can parse every_ms" do
    config = Map.put(@valid_config, :every_ms, 2)

    assert {:ok, config} = Workbench.BalanceSnapshots.Config.parse(config)
    assert config.every_ms == 2
  end
end

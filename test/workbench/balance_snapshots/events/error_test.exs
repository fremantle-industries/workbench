defmodule Workbench.BalanceSnapshots.Events.ErrorTest do
  use ExUnit.Case, async: true

  test ".to_data/1 transforms reason to a string" do
    event = %Workbench.BalanceSnapshots.Events.Error{
      reason: [{:market_quote_not_found, :btc_usd}]
    }

    assert TaiEvents.LogEvent.to_data(event) == %{
             reason: "[market_quote_not_found: :btc_usd]"
           }
  end
end

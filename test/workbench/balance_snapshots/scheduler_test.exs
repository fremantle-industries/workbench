defmodule Workbench.BalanceSnapshots.SchedulerTest do
  use ExUnit.Case, async: true
  import Mock

  @test_name __MODULE__
  @balance struct(Workbench.Balance)
  @usd_quote_venue :venue_a
  @config struct(
            Workbench.BalanceSnapshots.Config,
            enabled: true,
            boot_delay_ms: 0,
            every_ms: 1,
            usd_quote_venue: @usd_quote_venue
          )

  setup do
    Process.register(self(), @test_name)
    :ok
  end

  test "creates a snapshot after a boot delay" do
    Workbench.Schoolbus.subscribe(:balance_snapshot)

    with_mock Workbench.BalanceSnapshots.Snapshot, create: fn _config -> {:ok, @balance} end do
      {:ok, _} = Workbench.BalanceSnapshots.Scheduler.start_link(config: @config, id: @test_name)

      assert_receive {:balance_snapshot, :new_balance, balance}
      assert balance == @balance
    end
  end

  test "creates a snapshot on a regular schedule" do
    Workbench.Schoolbus.subscribe(:balance_snapshot)

    with_mock Workbench.BalanceSnapshots.Snapshot,
      create: fn _config -> {:ok, @balance} end do
      {:ok, _} = Workbench.BalanceSnapshots.Scheduler.start_link(config: @config, id: @test_name)

      assert_receive {:balance_snapshot, :new_balance, _balance}
      assert_receive {:balance_snapshot, :new_balance, _balance}
      assert_receive {:balance_snapshot, :new_balance, _balance}
    end
  end

  test "doesn't create a snapshot when disabled" do
    disabled_config = @config |> Map.put(:enabled, false)

    with_mock Workbench.BalanceSnapshots.Snapshot, create: fn _config -> {:ok, @balance} end do
      {:ok, _} =
        Workbench.BalanceSnapshots.Scheduler.start_link(config: disabled_config, id: @test_name)

      refute_receive {:balance_snapshot, :new_balance, _balance}
    end
  end

  test "logs an event when there is an error taking the snapshot" do
    TaiEvents.firehose_subscribe()

    with_mock Workbench.BalanceSnapshots.Snapshot,
      create: fn _config -> {:error, :not_found} end do
      {:ok, _} = Workbench.BalanceSnapshots.Scheduler.start_link(config: @config, id: @test_name)

      assert_receive {TaiEvents.Event, event, :error}
      assert %Workbench.BalanceSnapshots.Events.Error{} = event
      assert event.reason == :not_found
    end
  end
end

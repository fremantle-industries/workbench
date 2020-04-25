defmodule Workbench.BalanceSnapshots.SchedulerTest do
  use ExUnit.Case, async: true
  import Mock

  @test_name __MODULE__

  setup do
    Process.register(self(), @test_name)

    :ok
  end

  @balance struct(Workbench.Balance)
  @usd_quote_venue :venue_a

  setup do
    config =
      struct(
        Workbench.BalanceSnapshots.Config,
        enabled: true,
        boot_delay_ms: 0,
        every_ms: 1,
        after_snapshot: fn balance ->
          send(@test_name, {:after_snapshot, balance})
        end,
        usd_quote_venue: @usd_quote_venue
      )

    {:ok, %{config: config}}
  end

  test "creates a snapshot after a boot delay & fires the 'after_snapshot' callback", %{
    config: config
  } do
    with_mock Workbench.BalanceSnapshots.Snapshot, create: fn _config -> {:ok, @balance} end do
      {:ok, _} = Workbench.BalanceSnapshots.Scheduler.start_link(config: config, id: @test_name)

      assert_receive {:after_snapshot, balance}
      assert balance == @balance
    end
  end

  test "creates a snapshot on a regular schedule & fires the 'after_snapshot' callback", %{
    config: config
  } do
    with_mock Workbench.BalanceSnapshots.Snapshot,
      create: fn _config -> {:ok, @balance} end do
      {:ok, _} = Workbench.BalanceSnapshots.Scheduler.start_link(config: config, id: @test_name)

      assert_receive {:after_snapshot, _balance}
      assert_receive {:after_snapshot, _balance}
      assert_receive {:after_snapshot, _balance}
    end
  end

  test "doesn't create a snapshot when disabled", %{
    config: config
  } do
    disabled_config = config |> Map.put(:enabled, false)

    with_mock Workbench.BalanceSnapshots.Snapshot, create: fn _config -> {:ok, @balance} end do
      {:ok, _} =
        Workbench.BalanceSnapshots.Scheduler.start_link(config: disabled_config, id: @test_name)

      refute_receive {:after_snapshot, _}
    end
  end

  test "logs an event when there is an error taking the snapshot", %{config: config} do
    Tai.Events.firehose_subscribe()

    with_mock Workbench.BalanceSnapshots.Snapshot,
      create: fn _config -> {:error, :not_found} end do
      {:ok, _} = Workbench.BalanceSnapshots.Scheduler.start_link(config: config, id: @test_name)

      assert_receive {Tai.Event, event, :error}
      assert %Workbench.BalanceSnapshots.Events.Error{} = event
      assert event.reason == :not_found
    end
  end
end

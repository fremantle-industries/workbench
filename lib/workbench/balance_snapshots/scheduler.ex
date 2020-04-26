defmodule Workbench.BalanceSnapshots.Scheduler do
  use GenServer
  alias Workbench.BalanceSnapshots

  defmodule State do
    @type config :: BalanceSnapshots.Config.t()
    @type t :: %State{id: atom, config: config}

    @enforce_keys ~w(id config)a
    defstruct ~w(id config)a
  end

  @default_id :default

  def start_link(args) do
    config = Keyword.fetch!(args, :config)
    id = Keyword.get(args, :id, @default_id)
    name = id |> to_name()
    state = %State{id: id, config: config}

    GenServer.start_link(__MODULE__, state, name: name)
  end

  def to_name(id \\ @default_id), do: :"#{__MODULE__}_#{id}"

  def init(state) do
    if state.config.enabled do
      Process.send_after(self(), :start_snapshot, state.config.boot_delay_ms)
    end

    {:ok, state}
  end

  def handle_info(:start_snapshot, state) do
    state.config
    |> BalanceSnapshots.Snapshot.create()
    |> case do
      {:ok, balance} ->
        state.config.after_snapshot.(balance)
        Process.send_after(self(), :start_snapshot, state.config.every_ms)

      {:error, reason} ->
        BalanceSnapshots.Events.Error
        |> struct!(reason: reason)
        |> TaiEvents.error()
    end

    {:noreply, state}
  end
end

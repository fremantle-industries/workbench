defmodule BackOffice.BalanceSnapshots.Events.Error do
  alias __MODULE__

  @type t :: %Error{
          reason: term
        }

  @enforce_keys ~w(reason)a
  defstruct ~w(reason)a
end

defimpl Tai.LogEvent, for: BackOffice.BalanceSnapshots.Events.Error do
  def to_data(event) do
    keys =
      event
      |> Map.keys()
      |> Enum.filter(&(&1 != :__struct__))

    event
    |> Map.take(keys)
    |> Map.put(:reason, event.reason |> inspect)
  end
end

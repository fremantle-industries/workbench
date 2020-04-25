defmodule WorkbenchWeb.User do
  alias __MODULE__

  @type t :: %User{
          id: String.t(),
          provider: String.t(),
          name: String.t(),
          avatar: String.t()
        }

  @enforce_keys ~w(id provider name avatar)a
  defstruct ~w(id provider name avatar)a
end

defimpl Stored.Item, for: WorkbenchWeb.User do
  def key(u), do: {u.id, u.provider}
end

defmodule Workbench.Config do
  defstruct ~w(
    asset_aliases
    balance_snapshot
  )a
  use Vex.Struct
  alias __MODULE__

  @type asset :: Tai.Markets.Asset.symbol()
  @type t :: %Config{
          asset_aliases: %{asset => [asset]},
          balance_snapshot: map
        }

  # validates(:asset_aliases, presence: true)
  # validates(:balance_snapshot, presence: true)

  def parse(env \\ Application.get_all_env(:workbench)) do
    config = %Config{
      asset_aliases: Keyword.get(env, :asset_aliases, %{}),
      balance_snapshot: Keyword.get(env, :balance_snapshot, %{})
    }

    if Vex.valid?(config) do
      {:ok, config}
    else
      errors = Vex.errors(config)
      {:error, errors}
    end
  end

  def libcluster_topologies do
    Confex.get_env(:libcluster, :topologies, [])
  end
end

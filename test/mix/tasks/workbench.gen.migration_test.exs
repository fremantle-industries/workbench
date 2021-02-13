defmodule Mix.Tasks.Workbench.Gen.MigrationTest do
  use ExUnit.Case, async: true
  import Mix.Tasks.Workbench.Gen.Migration, only: [run: 1]
  import Workbench.TestSupport.FileHelpers

  @tmp_path Path.join(tmp_path(), inspect(Workbench.Gen.Migration))
  @migrations_path Path.join(@tmp_path, "migrations")

  defmodule My.Repo do
    def __adapter__ do
      true
    end

    def config do
      [priv: Path.join("priv/temp", inspect(Workbench.Gen.Migration)), otp_app: :workbench]
    end
  end

  setup do
    create_dir(@migrations_path)
    on_exit(fn -> destroy_tmp_dir("priv/temp/Workbench.Gen.Migration") end)
    :ok
  end

  test "generates a new migration" do
    run(["-r", to_string(My.Repo)])
    migrations = @migrations_path |> File.ls!() |> Enum.sort()

    assert Enum.count(migrations) > 0
    assert String.match?(Enum.at(migrations, 0), ~r/^\d{14}_create_workbench_balances.exs$/)
    assert String.match?(Enum.at(migrations, 1), ~r/^\d{14}_create_workbench_wallets.exs$/)
  end
end

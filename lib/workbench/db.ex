defmodule Workbench.Db do
  @spec db_prefix :: atom | nil
  def db_prefix do
    :workbench
    |> Application.get_env(:db_prefix, nil)
  end
end

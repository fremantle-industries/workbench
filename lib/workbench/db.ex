defmodule Workbench.Db do
  @spec db_prefix :: atom | nil
  def db_prefix do
    Application.get_env(:workbench, :db_prefix, nil)
  end
end

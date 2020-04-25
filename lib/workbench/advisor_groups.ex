defmodule Workbench.AdvisorGroups do
  @type group :: Tai.AdvisorGroup.t()

  @spec all :: [group]
  def all do
    config = Tai.Config.parse()
    {:ok, groups} = Tai.Advisors.Groups.from_config(config.advisor_groups)

    groups
  end

  @spec find(String.t()) :: {:ok, group} | {:error, :not_found}
  def find(id) do
    group_id = String.to_atom(id)
    groups = all()

    groups
    |> Enum.find(&(&1.id == group_id))
    |> case do
      nil -> {:error, :not_found}
      group -> {:ok, group}
    end
  end
end

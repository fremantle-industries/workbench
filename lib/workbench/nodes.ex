defmodule Workbench.Nodes do
  @type node_name :: String.t()

  @spec nodes :: [node_name]
  def nodes do
    [node() | Node.list()]
    |> Enum.map(&Atom.to_string/1)
  end

  @spec this :: node_name
  def this, do: node() |> Atom.to_string()

  @spec connected?(node_name) :: boolean
  def connected?(node) do
    nodes() |> Enum.member?(node)
  end
end

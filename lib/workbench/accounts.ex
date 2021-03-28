defmodule Workbench.Accounts do
  @zero Decimal.new(0)

  def where(node_param, filters) do
    show_zero = filters |> Keyword.get(:show_zero, false)

    [node: String.to_atom(node_param)]
    |> Tai.Commander.accounts()
    |> Enum.filter(fn ab ->
      if show_zero do
        ab
      else
        Decimal.compare(ab.free, @zero) != :eq || Decimal.compare(ab.locked, @zero) != :eq
      end
    end)
  end
end

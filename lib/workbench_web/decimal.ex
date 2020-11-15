defmodule WorkbenchWeb.Decimal do
  def decimal(d) do
    Decimal.to_string(d, :normal)
  end

  def round_down(d, precision) do
    p = Decimal.new(precision)

    d
    |> Tai.Utils.Decimal.round_down(p)
    |> Decimal.normalize()
    |> Decimal.to_string(:normal)
  end
end

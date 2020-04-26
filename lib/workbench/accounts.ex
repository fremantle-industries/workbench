defmodule Workbench.Accounts do
  @zero Decimal.new(0)

  def where(filters) do
    show_zero = filters |> Keyword.get(:show_zero, false)

    Tai.Venues.AccountStore.all()
    |> Enum.filter(fn ab ->
      if show_zero do
        ab
      else
        Decimal.cmp(ab.free, @zero) != :eq || Decimal.cmp(ab.locked, @zero) != :eq
      end
    end)
  end
end

defmodule BackOffice.Accounts do
  @zero Decimal.new(0)

  def where(filters) do
    show_zero = filters |> Keyword.get(:show_zero, false)

    Tai.Venues.AccountStore.all()
    |> Enum.filter(fn a ->
      if show_zero do
        a
      else
        Decimal.cmp(a.free, @zero) != :eq || Decimal.cmp(a.locked, @zero) != :eq
      end
    end)
  end
end

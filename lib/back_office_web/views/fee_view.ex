defmodule BackOfficeWeb.FeeView do
  use BackOfficeWeb, :view

  @attrs ~w(
    venue_id
    product_symbol
    credential_id
    maker
    maker_type
    taker
    taker_type
  )a
  def attrs, do: @attrs

  def pluck(attr, product), do: product |> Map.get(attr) |> format

  def format(nil), do: "-"
  def format(%Decimal{} = val), do: val |> decimal()
  def format(%DateTime{} = val), do: val |> from_now()
  def format(val) when is_binary(val) or is_atom(val), do: val
end

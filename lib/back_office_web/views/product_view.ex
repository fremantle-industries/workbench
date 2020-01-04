defmodule BackOfficeWeb.ProductView do
  use BackOfficeWeb, :view

  @attrs ~w(
    venue_symbol
    alias
    base
    quote
    type
    status
    listing
    expiry
    price_increment
    size_increment
    min_price
    min_size
    max_price
    max_size
    min_notional
    value
    is_quanto
    is_inverse
    maker_fee
    taker_fee
  )a
  def attrs, do: @attrs

  def pluck(attr, product), do: product |> Map.get(attr) |> format

  def format(nil), do: "-"
  def format(%Decimal{} = val), do: val |> decimal()
  def format(%DateTime{} = val), do: val |> from_now()
  def format(val) when is_binary(val) or is_atom(val), do: val
end

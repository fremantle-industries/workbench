defmodule Workbench.SmokeTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  feature "users have names", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.css("h3", text: "All Balances"))
    |> click(Query.link("Advisors"))
    |> assert_has(Query.css("h2", text: "Groups & Advisors"))
  end
end

defmodule Workbench.SmokeTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @tag :skip
  feature "workbench loads", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.css("h2", text: "All Balances"))
    |> click(Query.link("Advisors"))
    |> assert_has(Query.css("h2", text: "Groups & Advisors"))
  end
end

defmodule WorkbenchWeb.IconView do
  use WorkbenchWeb, :view

  def render("_check_circle.html", assigns) do
    class = assigns[:class]
    title = assigns[:title]

    icon = ~E"""
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 <%= class %>" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    """

    if title != nil do
      ~E"""
      <span title="<%= title %>"><%= icon %></span>
      """
    else
      icon
    end
  end

  def render("_minus_circle.html", assigns) do
    class = assigns[:class]
    title = assigns[:title]

    icon = ~E"""
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 <%= class %>" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    """

    if title != nil do
      ~E"""
      <span title="<%= title %>"><%= icon %></span>
      """
    else
      icon
    end
  end
end

defmodule WorkbenchWeb.OrderTransitionView do
  use WorkbenchWeb, :view

  def render("show.html", assigns) do
    transition = assigns.transition
    %transition_type{} = assigns.transition
    attrs = Map.from_struct(transition)

    ~E"""
    <%= Enum.map(attrs, fn {k, v} -> %>
      <div>
        <dt class="font-bold"><%= k %>:</dt>
        <dd><%= render_value(v, transition_type, k) %></dd>
      </div>
    <% end) %>
    """
  end

  defp render_value(trace, _transition_type, :stacktrace) do
    ~E"""
    <ul>
      <%= Enum.map trace, fn entry -> %>
        <li><%= entry |> Exception.format_stacktrace_entry() %></li>
      <% end %>
    </ul>
    """
  end

  defp render_value(%Decimal{} = value, _transition_type, _attr_name) do
    value |> Decimal.to_string(:normal)
  end

  defp render_value(%DateTime{} = value, _transition_type, _attr_name) do
    ~E"""
    <span title="<%= value %>">
      <%= value |> Timex.from_now() %>
    </span>
    """
  end

  defp render_value(value, _transition_type, _attr_name) when is_bitstring(value) do
    value
  end

  defp render_value(value, _transition_type, _attr_name) do
    value |> inspect
  end
end

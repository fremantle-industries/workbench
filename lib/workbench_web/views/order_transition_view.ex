defmodule WorkbenchWeb.OrderTransitionView do
  use WorkbenchWeb, :view

  def render("show.html", assigns) do
    transition = assigns.transition
    %transition_type{} = assigns.transition
    attrs = Map.from_struct(transition)

    ~H"""
    <%= Enum.map(attrs, fn {k, v} -> %>
      <div>
        <dt class="font-bold"><%= k %>:</dt>
        <dd><%= render_value(v, transition_type, k, assigns) %></dd>
      </div>
    <% end) %>
    """
  end

  defp render_value(trace, _transition_type, :stacktrace, assigns) do
    ~H"""
    <ul>
      <%= Enum.map trace, fn entry -> %>
        <li><%= entry |> Exception.format_stacktrace_entry() %></li>
      <% end %>
    </ul>
    """
  end

  defp render_value(%Decimal{} = value, _transition_type, _attr_name, _assigns) do
    value |> Decimal.to_string(:normal)
  end

  defp render_value(%DateTime{} = value, _transition_type, _attr_name, assigns) do
    ~H"""
    <span title={value}>
      <%= value |> Timex.from_now() %>
    </span>
    """
  end

  defp render_value(value, _transition_type, _attr_name, _assigns) when is_bitstring(value) do
    value
  end

  defp render_value(value, _transition_type, _attr_name, _assigns) do
    value |> inspect
  end
end

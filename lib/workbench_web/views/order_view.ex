defmodule WorkbenchWeb.OrderView do
  use WorkbenchWeb, :view

  def render("_status.html", assigns) do
    class = assigns[:class] || ""

    color_class =
      case assigns.status do
        :enqueued -> ["bg-yellow-50", "text-yellow-500"]
        :create_accepted -> ["bg-purple-50", "text-purple-500"]
        :cancel_accepted -> ["bg-purple-50", "text-purple-500"]
        :amend_accepted -> ["bg-purple-50", "text-purple-500"]
        :open -> ["bg-blue-50", "text-blue-500"]
        :filled -> ["bg-green-50", "text-green-500"]
        :pending_cancel -> ["bg-purple-100", "text-purple-500"]
        :pending_amend -> ["bg-purple-100", "text-purple-500"]
        :create_error -> ["bg-red-50", "text-red-500"]
        _ -> ["bg-gray-100"]
      end
      |> Enum.join(" ")

    ~H"""
    <span class={"rounded-lg px-2 py-1 #{class} #{color_class}"}>
      <%= assigns.status %>
    </span>
    """
  end

  def render("_summary.html", assigns) do
    ~H"""
    <div>
      <div class="space-y-4">
        <dt class="inline-block font-bold w-52">Side:</dt>
        <dd class="inline-block"><%= assigns.order.side %></dd>
      </div>
      <div class="space-y-4">
        <dt class="inline-block font-bold w-52">Status:</dt>
        <dd class="inline-block">
          <%= render WorkbenchWeb.OrderView, "_status.html", status: assigns.order.status %>
        </dd>
      </div>
      <div class="space-y-4">
        <dt class="inline-block font-bold w-52">Enqueued At:</dt>
        <dd class="inline-block"><%= assigns.order.inserted_at %></dd>
      </div>
      <div class="space-y-4">
        <dt class="inline-block font-bold w-52">Updated At:</dt>
        <dd class="inline-block"><%= assigns.order.updated_at %></dd>
      </div>
      <div class="space-y-4">
        <dt class="inline-block font-bold w-52">Last Received At:</dt>
        <dd class="inline-block"><%= assigns.order.last_received_at || "-"  %></dd>
      </div>
      <div class="space-y-4">
        <dt class="inline-block font-bold w-52">Last Venue Timestamp:</dt>
        <dd class="inline-block"><%= assigns.order.last_venue_timestamp || "-" %></dd>
      </div>
    </div>
    """
  end
end

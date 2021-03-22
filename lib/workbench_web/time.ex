defmodule WorkbenchWeb.Time do
  def relative_time(%DateTime{} = d) do
    relative = Timex.format!(d, "{relative}", :relative)
    Phoenix.HTML.Tag.content_tag(:span, relative, title: d)
  end

  def relative_time(d) when is_integer(d) do
    (d + System.time_offset(:microsecond))
    |> DateTime.from_unix!(:microsecond)
    |> relative_time()
  end
end

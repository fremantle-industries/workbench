defmodule WorkbenchWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      {TelemetryMetricsPrometheus,
       [metrics: metrics(), name: prometheus_metrics_name(), port: prometheus_metrics_port()]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      last_value("phoenix.endpoint.stop.duration",
        tags: [:method, :request_path],
        tag_values: &tag_method_and_request_path/1,
        unit: {:native, :millisecond}
      ),
      last_value("phoenix.router_dispatch.stop.duration",
        tags: [:controller_action],
        tag_values: &tag_controller_action/1,
        unit: {:native, :millisecond}
      ),

      # Database Time Metrics
      last_value("monitor.repo.query.total_time", unit: {:native, :millisecond}),
      last_value("monitor.repo.query.decode_time", unit: {:native, :millisecond}),
      last_value("monitor.repo.query.query_time", unit: {:native, :millisecond}),
      last_value("monitor.repo.query.queue_time", unit: {:native, :millisecond}),
      last_value("monitor.repo.query.idle_time", unit: {:native, :millisecond}),

      # VM Metrics
      last_value("vm.memory.total", unit: {:byte, :kilobyte}),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io"),

      # Tai Metrics
      counter("tai.venues.stream.connect.total", tags: [:venue]),
      counter("tai.venues.stream.disconnect.total", tags: [:venue])
    ]
  end

  defp prometheus_metrics_name do
    Application.get_env(:workbench, :prometheus_metrics_name, :workbench_prometheus_metrics)
  end

  defp prometheus_metrics_port do
    Application.get_env(:workbench, :prometheus_metrics_port, 9568)
  end

  defp periodic_measurements do
    []
  end

  # Extracts labels like "GET /"
  defp tag_method_and_request_path(metadata) do
    Map.take(metadata.conn, [:method, :request_path])
  end

  # Extracts controller#action from route dispatch
  defp tag_controller_action(%{plug: plug, plug_opts: plug_opts}) when is_atom(plug_opts) do
    %{controller_action: "#{inspect(plug)}##{plug_opts}"}
  end

  defp tag_controller_action(%{plug: plug}) do
    %{controller_action: inspect(plug)}
  end
end

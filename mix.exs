defmodule Workbench.MixProject do
  use Mix.Project

  def project do
    [
      app: :workbench,
      version: "0.0.17",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package(),
      dialyzer: [
        plt_add_apps: [:tai, :mix]
      ]
    ]
  end

  def application do
    [
      mod: {Workbench.Application, []},
      extra_applications: app_list(Mix.env())
    ]
  end

  @dotenvs ~w(dev test)a
  defp app_list(env) when env in @dotenvs, do: [:dotenv | app_list()]
  defp app_list(_), do: app_list()
  defp app_list, do: [:logger, :runtime_tools, :tai, :notified]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:decimal, "~> 2.0"},
      {:deque, "~> 1.0"},
      {:ecto_sql, "~> 3.1"},
      {:enumerati, "~> 0.0.8"},
      {:gettext, "~> 0.19.0"},
      {:jason, "~> 1.0"},
      {:libcluster, "~> 3.2"},
      {:navigator, "~> 0.0.6"},
      {:notified_phoenix, "~> 0.0.7"},
      {:number, "~> 1.0.0"},
      {:phoenix, "~> 1.6.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:schoolbus, "~> 0.0.3"},
      {:stored, "~> 0.0.8"},
      # {:stylish, github: "fremantle-industries/stylish", branch: "ping"},
      {:stylish, "~> 0.0.2"},
      # {:tai, github: "fremantle-industries/tai", sparse: "apps/tai", branch: "main", override: true},
      {:tai, "~> 0.0.73"},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_metrics_prometheus, "~> 1.1"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, "~> 3.7"},
      {:vex, "~> 0.7"},
      # {:dotenv, "~> 3.1.0", only: [:dev, :test]},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:dotenv, "~> 3.1.0", only: [:dev, :test]},
      {:logger_file_backend, "~> 0.0.1", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:floki, ">= 0.0.0", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:wallaby, "~> 0.29.0", runtime: false, only: :test}
    ]
  end

  defp description do
    "From Idea to Execution - Manage your trading operation across a distributed cluster"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-industries/workbench"}
    }
  end

  defp aliases do
    [
      "setup.deps": ["deps.get", "cmd npm install --prefix assets"],
      setup: ["setup.deps", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end

defmodule Workbench.MixProject do
  use Mix.Project

  def project do
    [
      app: :workbench,
      version: "0.0.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package(),
      dialyzer: [
        plt_add_apps: [:tai]
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
  defp app_list, do: [:logger, :runtime_tools, :os_mon, :ueberauth_google, :tai]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:decimal, "~> 2.0"},
      {:enumerati, "~> 0.0.8"},
      {:stored, "~> 0.0.4"},
      {:tai, "~> 0.0.58"},
      {:logger_json, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:phoenix, "~> 1.5"},
      {:phoenix_live_view, "~> 0.15"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_active_link, "~> 0.3"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.18.0"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.1"},
      {:number, "~> 1.0.0"},
      {:guardian, "~> 2.0"},
      {:ueberauth_google, "~> 0.8"},
      {:vex, "~> 0.7"},
      {:deque, "~> 1.0"},
      {:schoolbus, "~> 0.0.3"},
      {:telemetry, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:libcluster, "~> 3.2"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:logger_file_backend_with_formatters, "~> 0.0.1", only: [:dev, :test]},
      {:logger_file_backend_with_formatters_stackdriver, "~> 0.0.4", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "From Idea to Execution - Manage your trading operation across a globally distributed cluster"
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

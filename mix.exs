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
      deps: deps(),
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
  defp app_list, do: [:logger, :runtime_tools, :ueberauth_google, :tai]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:enumerati, "~> 0.0.5"},
      {:stored, "~> 0.0.4"},
      {:tai, "~> 0.0.55"},
      {:logger_json, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:phoenix, "~> 1.4.9"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_view, "~> 0.4"},
      {:phoenix_active_link, "~> 0.3"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.17"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:number, "~> 1.0.0"},
      {:wrap, "~> 0.0.7"},
      {:guardian, "~> 2.0"},
      {:ueberauth_google, "~> 0.8"},
      {:vex, "~> 0.7"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:logger_file_backend_with_formatters, "~> 0.0.1", only: [:dev, :test]},
      {:logger_file_backend_with_formatters_stackdriver, "~> 0.0.4", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:floki, ">= 0.0.0", only: :test}
    ]
  end
end

defmodule Waw.MixProject do
  use Mix.Project

  def project do
    [
      app: :waw,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:phoenix, "~> 1.8"},
      {:phoenix_live_view, "~> 1.0"},
      {:ex_cldr, "~> 2.37"},
      {:ex_cldr_units, "~> 3.0"},
      {:ex_cldr_numbers, "~> 2.32"},
      {:ex_cldr_dates_times, "~> 2.14"},
      {:ex_cldr_calendars, "~> 2.2"},
      {:zoneinfo, "~> 0.1"},
      {:gettext, "~> 0.20"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

defmodule Dbparser.Mixfile do
  use Mix.Project

  def project do
    [app: :dbparser,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     deps: deps()]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:travis), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [applications: [:logger, :httpoison, :timex],
     mod: {Main, []}]
  end

  defp deps do
    [ {:poison, "~> 2.0"}, {:httpoison, "~> 0.9.0"}, {:timex, "~> 3.0"} ]
  end
end

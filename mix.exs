defmodule QuickCrud.MixProject do
  use Mix.Project

  def project do
    [
      app: :quick_crud,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {QuickCrud.Application, []}
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      setup: ["ecto.create --quiet", "ecto.migrate"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:query_builder, "~> 1.4"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:ex_machina, "~> 2.7", only: [:dev, :test]},
      {:maxo_test_iex, "~> 0.1", only: :test}
    ]
  end
end

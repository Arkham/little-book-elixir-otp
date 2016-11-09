defmodule ConcuerrorPlayground.Mixfile do
  use Mix.Project

  def project do
    [app: :concuerror_playground,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixir_paths: elixirc_paths(Mix.env),
     test_pattern: "*_test.ex*",
     warn_test_pattern: nil,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp elixirc_paths(:test), do: ["lib", "test/concurrency"]
  defp elixirc_paths(_), do: ["lib"]
end

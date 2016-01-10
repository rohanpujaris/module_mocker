defmodule ModuleMocker.Mixfile do
  use Mix.Project

  def project do
    [app: :module_mocker,
     version: "0.2.0",
     description: description,
     package: packages,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp description do
    """
    ModuleMocker allows to use different module in development and test environment.
    It allows convention to mock module for test
    """
  end

  defp packages do
    [
      files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Rohan Pujari"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rohanpujaris/module_mocker"}
    ]
  end
end

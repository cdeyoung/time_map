defmodule Instacart.MixProject do
  use Mix.Project

  def project do
    [
      app: :instacart,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [
        :logger,
        :timex
      ]
    ]
  end

  defp deps do
    [
      {:timex, "~> 3.3"}
    ]
  end
end

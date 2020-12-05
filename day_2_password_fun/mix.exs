defmodule Day2PasswordFun.MixProject do
  use Mix.Project

  def project do
    [
      app: :day_2_password_fun,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end

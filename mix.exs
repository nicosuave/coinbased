defmodule Coinbased.Mixfile do
  use Mix.Project

  @description """
    A simple Elixir wrapper for Coinbase's v2 Wallet API
  """

  def project do
    [app: :coinbased,
     version: "0.0.1",
     elixir: "~> 1.0",
     name: "Coinbased",
     description: @description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:httpoison, :exjsx, :tzdata]]
  end

  defp deps do
    [
      { :httpoison, "~> 0.7.3" },
      { :exjsx, "~> 3.0" },
      { :timex, "~> 0.19.5" },
      { :earmark, "~> 0.1.17", only: :docs },
      { :ex_doc, "~> 0.8.0", only: :docs },
      { :meck, "~> 0.8.2", only: :test }
    ]
  end

  defp package do
    [ contributors: ["Nico Ritschel"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/nicosuave/coinbased" } ]
  end
end

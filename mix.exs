defmodule Pipes.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipe,
      version: "0.0.2",
      elixir: "~> 1.0",
      deps: deps,
      package: package,
      description: description ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end

  defp description do
    """
    An Elixir extension that extends the pipe (|>) operator through macros.
    """
  end

  defp package do
    [contributors: ["Bruce Tate"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/batate/elixir-pipes"}]
  end
end

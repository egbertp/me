defmodule PersonalWebsite.MixProject do
  use Mix.Project

  def project do
    [
      app: :personal_website,
      version: "0.1.0",
      elixir: "~> 1.20",
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
      {:nimble_publisher, "~> 2.1", runtime: false},
      {:makeup_elixir, ">= 0.0.0", runtime: false},
      {:makeup_erlang, ">= 0.0.0", runtime: false},
      {:makeup_js, ">= 0.0.0", runtime: false},
      {:makeup_html, ">= 0.0.0", runtime: false},
      {:phoenix_live_view, "~> 1.2"},
      {:xml_builder, "~> 2.4"},
      {:yaml_elixir, "~> 2.12"},
      {:html_sanitize_ex, "~> 1.4"},
      {:tailwind, "~> 0.5.1"},
      {:exsync, "~> 0.4", only: :dev},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

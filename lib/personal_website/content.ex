defmodule PersonalWebsite.Content do
  @moduledoc false

  alias PersonalWebsite.Page

  use NimblePublisher,
    build: Page,
    from: "./pages/**/*.md",
    as: :pages,
    highlighters: [:makeup_elixir, :makeup_js, :makeup_html],
    earmark_options: [breaks: true]

  def site_title() do
    "egbertpot.nl"
  end

  def site_description() do
    "Egbert's personal blog on building data and communication systems"
  end

  def site_author() do
    "Egbert Pot"
  end

  def site_url() do
    "https://egbertpot.nl"
  end

  def site_email() do
    "hi@egbertpot.nl"
  end

  def site_copyright() do
    "This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License."
  end

  def redirects() do
    %{
      "/feed.xml" => "/index.xml",
      "/rss.xml" => "/index.xml",
      "/feed/index.html" => "/index.xml",
      "/blog/index.html" => "/",
      "/post/index.html" => "/",
      "/posts/index.html" => "/"
    }
  end

  def all_posts do
    @pages |> Enum.filter(&(&1.type == :post)) |> Enum.sort_by(& &1.date, {:desc, Date})
  end

  def active_posts do
    all_posts() |> Enum.reject(& &1.archive)
  end

  def about_page do
    @pages |> Enum.find(&(&1.id == "about"))
  end

  def not_found_page do
    @pages |> Enum.find(&(&1.id == "404"))
  end

  def get_reads() do
    for filename <- File.ls!("pages/reads") do
      id = Path.rootname(filename)
      src_path = Path.join("pages/reads/", filename)
      data = YamlElixir.read_from_file!(src_path)
      html_path = "/reads/#{id}/index.html"

      %{
        id: id,
        date: DateTime.utc_now(),
        type: :reads,
        title: data["title"],
        description: data["description"],
        links: data["links"],
        src_path: src_path,
        html_path: html_path,
        route: Path.join("/", Path.dirname(html_path)) <> "/"
      }
    end
  end

  def all_pages do
    [about_page()] ++ all_posts() ++ get_reads()
  end
end

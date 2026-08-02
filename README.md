# egbertpot.nl - Egbert's personal blog

This my personal website. I'm using this super simple Elixir project to generate static `html` + `css` + `js` that I can host on my super small `virtual machine` runnig in the Amsterdam region on a € 3/month [Upcloud](https://upcloud.com/) virtual machine of the `starter-1gb` plan that runs [OpenBSD 7.9](https://www.openbsd.org/)

## Structure

- `pages/` contains the markdown and YAML content I regularly publish
- `assets/` contains static content
- `lib/` contains the code generating the side
- `output/` is where the generated files are rendered


## Running

- `mix deps.get` to install dependencies
- `mix compile` compiles code and generates the site during the compile step. This runs on commits using a Github Action.
- `iex -S mix` runs a dev server serving the side for local development


## Acknowledgement

Thanks to [Moving the Blog to Elixir](https://jorin.me/moving-the-blog-to-elixir/) from [Jorion](https://bsky.app/profile/jorin.me) and [fly.io's post on SSG using Elixir](https://fly.io/phoenix-files/crafting-your-own-static-site-generator-using-phoenix/) for helping me getting started.


## License

[![Creative Commons Attribution-ShareAlike 3.0 Unported License](https://licensebuttons.net/l/by-sa/3.0/80x15.png)](https://creativecommons.org/licenses/by-sa/3.0/)

The content is licensed under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](https://creativecommons.org/licenses/by-sa/3.0/). The code is licensed under the [MIT license](https://opensource.org/licenses/MIT).

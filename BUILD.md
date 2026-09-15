# Building & publishing the site

The site is generated from a single markdown source, `readme.md`, by
[pandoc](https://pandoc.org/). That same file is also the repository readme, so
it renders on GitHub too (with the interactive embeds degrading to nothing — see
below).

## Build locally

```sh
make        # readme.md -> index.html
make serve  # build, then serve at http://localhost:8000
make clean
```

Requires `pandoc` and, for `serve`, `python3`.

## How it publishes

`.github/workflows/pages.yml` runs `make` on every push to `main`, assembles
`index.html` + `assets/` + `viz/` + the `*.svg` diagrams into `_site/`, and
deploys that to GitHub Pages. The generated `index.html` is never committed.

One-time setup: repo **Settings -> Pages -> Source: GitHub Actions**.

## Layout

```
readme.md              site source (and the repo readme)
assets/
  template.html        pandoc HTML template (theme + MathJax + iframe resizer)
  style.css            shared theme for the page and every viz
  viz-embed.js         child-side height reporter for embedded viz
viz/                   standalone interactive visualizations (one file each)
*.svg                  static diagrams, referenced from readme.md as images
Makefile
```

## Embedding interactive visualizations

Each visualization is a **self-contained HTML file** in `viz/`. Embed one inline
in the prose with a raw-HTML iframe — pandoc passes it straight through:

```html
<iframe class="viz" src="viz/my-thing.html" title="what it shows"></iframe>
```

Why iframes rather than inline `<script>` in the markdown:

- **Isolation.** Each viz has its own CSS and global JS scope. Two viz can both
  define `render()` or style `.slot` with no collision, and none of them can
  touch the page. No spooky action at a distance.
- **Clean source.** The markdown stays readable — one line per embed.
- **Independently testable.** Open `viz/my-thing.html` directly in a browser to
  develop it; no build step, no site scaffolding.

`viz/stack-demo.html` is a minimal reference to copy. Any embeddable viz should:

1. `<link rel="stylesheet" href="../assets/style.css">` to share the theme
   (the `../` works both standalone and when embedded from `index.html`).
2. Include `<script src="../assets/viz-embed.js"></script>` at the end of
   `<body>`. It reports the content height to the host page so the iframe
   auto-fits, even as the viz grows or shrinks on interaction.

Larger, article-length pieces (e.g. `viz/permute-algorithms.html`) can instead
be **linked** rather than embedded — they carry their own full-page layout.

### Note on GitHub's readme view

GitHub sanitizes `<iframe>` and `<script>` out of rendered markdown, so on the
repo's readme the embeds simply do not appear (the SVG diagrams and math still
do). They render only on the published Pages site. This is the accepted cost of
using one file for both purposes.

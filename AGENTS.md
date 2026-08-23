# AGENTS.md — jekyll-theme-kactus

## What This Is

A Jekyll blog theme — a port of [Cactus](https://github.com/koenbok/Cactus)'s default theme for Jekyll. Fully compatible with GitHub Pages. Used as a personal blog by the repo owner.

## Essential Commands

| Command | What it does |
|---|---|
| `jekyll serve` | Start local dev server at `http://localhost:4000/jekyll-theme-kactus/` |
| `jekyll build` | Build site into `_site/` directory |
| `bundle exec jekyll serve` | Run with Gemfile gems (preferred) |
| `bundle update` | Update gem dependencies after changing Gemfile |

Ruby version: **3.3.4** (from `.ruby-version`)

## Code Organization

```
_config.yml          — Site config (name, URL, pagination, analytics, Disqus, permalinks)
Gemfile              — Dependencies (github-pages gem only)
index.html           — Home page with profile + post list
about.md             — Static about page
feed.xml             — RSS feed template (Liquid)

_layouts/
  default.html       — Base layout: nav, profile block, content wrapper, GA, jQuery, highlight.js
  post.html          — Post layout: article header, sharing, Disqus, archive list

_includes/
  navigation.html    — Home/About/Subscribe nav bar
  profile.html       — Author avatar + name + description header
  post-list.html     — Paginated post list with dates
  pagination.html    — Newer/Older post navigation
  share.html         — Twitter + Facebook share buttons
  footer.html        — Copyright footer
  disqus.html        — Disqus comments embed

_posts/              — Blog posts as Markdown files with YAML front matter
_drafts/             — Unpublished draft posts

assets/
  css/style.css      — Main stylesheet (reset, layout, typography, responsive, print)
  css/highlight.css  — IR_Black code syntax highlighting theme
  js/main.js         — Retina image detection/swap (jQuery-dependent)
  js/highlight.js    — highlight.js for code blocks
  fonts/             — Custom icon font (icons.eot/.woff/.ttf/.svg)
  images/            — Blog images, favicon, avatar, screenshots
```

## Architecture & Control Flow

1. Jekyll processes all files in `_posts/` using YAML front matter + Markdown body
2. Each post gets wrapped in `_layouts/post.html` (which extends `_layouts/default.html`)
3. `index.html` renders the homepage with profile + paginated post list
4. `_config.yml` controls: site metadata, pagination (20 posts/page), Disqus, Google Analytics, permalink style (`/:year/:title/`)
5. Pages with `profile: true` in front matter show the author avatar/name/description
6. The RSS feed is a Liquid template (`feed.xml`) that iterates `site.posts limit:10`
7. No JavaScript framework — just jQuery + minimalist JS for retina images and highlight.js

## Front Matter Conventions

Every post must have:
```yaml
---
layout: post
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS +/-TTTT
description: "One-line summary for post list"
categories: [tag1, tag2]
tags: [tag1, tag2, tag3]
image: /jekyll-theme-kactus/assets/images/filename.svg
---
```

The `image` field is used for social share cards, not displayed inline. The `description` field renders as `<h2>` under each title in the post list.

## Key Patterns & Gotchas

- **All URLs use `relative_url` filter** — do not hardcode paths. Always use `{{ "/" | relative_url }}path/to/file` or `{{ site.baseurl }}/path/`. This is required for GitHub Pages subpath serving.
- **Permalink format**: `/:year/:title/` — so a post from 2026-08-23 with title "foo" lives at `/2026/foo/`. The filename date prefix is preserved in the URL year.
- **Single CSS file** — `style.css` contains reset, base, layout, typography, responsive, print, and all component styles. No CSS preprocessing.
- **No custom plugins** — only `jekyll-paginate` is used. Any new plugin must be GitHub Pages compatible.
- **Post metadata is in `_config.yml`** — author name, Twitter handle, Disqus shortname, Google Analytics ID, domain. Don't search for these in individual files.
- **Retina images** — add class `2x` to an `<img>` and provide a `filename@2x.png` variant. The JS in `main.js` auto-swaps on retina displays.
- **Disqus is opt-in** — set `disqus: true` in `_config.yml` and provide a `disqus_shortname`. Disabled by default.
- **No test suite** — this is a static Jekyll theme. No test framework exists.
- **No CI/CD config** — no `.github/` directory. Deploy via GitHub Pages or manual `jekyll build`.
- **`_site/` and `.sass-cache/` are gitignored** — never commit build output.
- **Posts can be `.markdown` or `.md`** — both extensions are used in this repo.
- **Draft posts** go in `_drafts/` with no date prefix needed in filename. View with `jekyll serve --drafts`.
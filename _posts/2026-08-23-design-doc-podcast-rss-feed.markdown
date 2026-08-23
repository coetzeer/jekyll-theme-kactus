---
layout: post
title: "Design Document: Podcast RSS Feed Generator for Jekyll Assets"
date: 2026-08-23
categories: design
---

# Design Document: Podcast RSS Feed Generator

## Problem Statement

I want to generate a podcast-compatible RSS feed that includes all MP3 files in the Jekyll site's assets directory (`/assets/audio/` or similar). This feed should be consumable by standard podcast players (Apple Podcasts, Spotify, Overcast, Pocket Casts, etc.).

## Requirements

### Functional Requirements

1. **Auto-discovery of MP3 files**: The feed should automatically include all `.mp3` files found in the assets directory (recursively).
2. **Podcast RSS 2.0 + iTunes extensions**: The feed must conform to the [Podcast RSS specification](https://github.com/Podcastindex-org/podcast-namespace) with iTunes/Apple Podcasts extensions (`<itunes:*>` tags).
3. **Episode metadata**: Each episode should include:
   - Title (derived from filename or ID3 tags)
   - Description
   - Publication date (file modification date or front matter)
   - Duration (from ID3 tags if available)
   - File size
   - MIME type (`audio/mpeg`)
   - GUID (stable, based on file path/hash)
   - Enclosure URL (absolute, with `baseurl` prefix)
   - Optional: episode number, season, episode type, explicit flag, image
4. **Feed-level metadata**:
   - Title, description, author, language
   - Categories (iTunes categories)
   - Feed image (cover art)
   - Link to website
   - Copyright/owner info
5. **Incremental builds**: Only regenerate feed when MP3 files change (leverage Jekyll's incremental build).
6. **Configurable**: Feed settings via `_config.yml`.

### Non-Functional Requirements

- Zero external dependencies beyond standard Jekyll/Ruby gems
- Works with GitHub Pages (no custom plugins that GH Pages doesn't support)
- Fast build times (< 5s for ~100 episodes)
- Validates against [Cast Feed Validator](https://castfeedvalidator.com/)

## Technical Approach

### Option 1: Jekyll Generator Plugin (Recommended)

Create a `_plugins/podcast_feed_generator.rb` that:
- Hooks into Jekyll's `generate` phase
- Scans `site.static_files` or `site.pages` for `.mp3` files
- Builds a `feed.xml` (or `podcast.xml`) in the site root
- Uses `Jekyll::Feed`-style XML builder or Nokogiri

**Pros**: Native Jekyll, incremental builds work, no external tools
**Cons**: GitHub Pages doesn't allow custom plugins (but we can generate locally and commit the output)

### Option 2: GitHub Actions Workflow

A workflow that:
- Runs on push to main
- Uses a Ruby script to scan `assets/` for MP3s
- Generates `podcast.xml` and commits it back

**Pros**: Works on GitHub Pages without local generation
**Cons**: Extra complexity, delayed feed updates

### Option 3: Liquid Template (Pure Jekyll)

A `podcast.xml` template using Liquid loops over `site.static_files`.

**Pros**: No plugins, works on GH Pages natively
**Cons**: Limited logic (no ID3 parsing, no duration), verbose Liquid

## Chosen Approach: Local Generator + Committed Output

Since the repo is deployed to GitHub Pages (which doesn't run custom plugins), we'll:

1. **Create a generator plugin** in `_plugins/podcast_feed_generator.rb` for local development
2. **Run `jekyll build` locally** to generate `podcast.xml` in `_site/`
3. **Copy `podcast.xml` to repo root** (or `assets/podcast.xml`) and commit it
4. **GitHub Pages serves the committed XML** directly

This gives us full Ruby power locally while staying GH Pages compatible.

## Implementation Details

### Directory Structure

```
jekyll-theme-kactus/
├── _plugins/
│   └── podcast_feed_generator.rb    # Generator plugin
├── _config.yml                       # Feed configuration
├── assets/
│   └── audio/                        # MP3 files go here
│       ├── episode-001.mp3
│       └── episode-002.mp3
├── podcast.xml                       # Generated output (committed)
└── _site/
    └── podcast.xml                   # Built output
```

### `_config.yml` Configuration

```yaml
podcast:
  title: "My Podcast"
  description: "Weekly thoughts on tech and life"
  author: "Raymond Coetzee"
  author_email: "raymond@example.com"
  language: "en-us"
  categories:
    - "Technology"
    - "Software Engineering"
  explicit: false
  image: "/jekyll-theme-kactus/assets/images/podcast-cover.jpg"
  site_url: "https://coetzeer.github.io/jekyll-theme-kactus"
  feed_path: "/jekyll-theme-kactus/podcast.xml"
  audio_dir: "assets/audio"
  # Optional iTunes fields
  itunes:
    owner_name: "Raymond Coetzee"
    owner_email: "raymond@example.com"
    category: "Technology"
    subcategory: "Software Engineering"
    keywords: "tech, programming, ruby, jekyll"
```

### Generator Plugin: `_plugins/podcast_feed_generator.rb`

Key implementation points:

```ruby
module Jekyll
  class PodcastFeedGenerator < Generator
    safe true
    priority :low

    def generate(site)
      config = site.config['podcast'] || {}
      return unless config['audio_dir']

      audio_files = find_audio_files(site, config['audio_dir'])
      return if audio_files.empty?

      feed = build_feed(site, config, audio_files)
      write_feed(site, feed, config['feed_path'] || 'podcast.xml')
    end

    private

    def find_audio_files(site, audio_dir)
      # Scan site.static_files + site.pages for .mp3 under audio_dir
      # Read ID3 tags for duration, title, artist using ruby-mp3info gem
      # Fall back to filename for title
      # Sort by date (front matter or mtime) descending
    end

    def build_feed(site, config, episodes)
      # Build RSS 2.0 with iTunes namespace
      # Use Builder::XmlMarkup or Nokogiri::XML::Builder
    end

    def write_feed(site, feed_xml, path)
      # Write to site.dest (for _site/) AND to source root (for commit)
    end
  end
end
```

### Dependencies

Add to `Gemfile` (local only, not needed for GH Pages since we commit output):

```ruby
group :jekyll_plugins do
  gem 'ruby-mp3info', '~> 0.8'  # For ID3 tag reading
  # Nokogiri and Builder are already Jekyll deps
end
```

### Usage

1. Drop MP3 files in `assets/audio/`
2. Run `bundle exec jekyll build`
3. Check generated `podcast.xml` in repo root
4. Commit and push
5. Subscribe to `https://coetzeer.github.io/jekyll-theme-kactus/podcast.xml`

### Episode Front Matter (Optional)

For richer metadata, add a companion `.md` or `.yml` file:

```
assets/audio/episode-001.mp3
assets/audio/episode-001.yml
```

```yaml
# episode-001.yml
title: "Episode 1: Getting Started with Jekyll"
description: "In this episode we discuss..."
date: 2026-08-15
explicit: false
episode: 1
season: 1
episode_type: full  # full, trailer, bonus
```

The generator reads this if present, otherwise falls back to ID3/filename.

## Validation Checklist

- [ ] Feed validates at https://castfeedvalidator.com/
- [ ] Feed validates at https://podba.se/validate/
- [ ] Apple Podcasts accepts the feed (test via Podcasts Connect)
- [ ] Episodes play in Overcast, Pocket Casts, Spotify
- [ ] GUIDs are stable across rebuilds (use file path + mtime hash)
- [ ] Enclosure URLs are absolute with correct `baseurl`
- [ ] Duration format is `HH:MM:SS` (iTunes requirement)
- [ ] Feed updates when new MP3s added
- [ ] Feed doesn't duplicate episodes on rebuild

## Future Enhancements

1. **Multiple feeds**: Support multiple podcast channels (e.g., "main", "bonus")
2. **Transcripts**: Include `<podcast:transcript>` link if `.vtt`/`.srt` exists
3. **Chapters**: Parse ID3 chapters or companion JSON for `<podcast:chapters>`
4. **Analytics**: Add `<podcast:analytics>` prefix for OP3/Podtrac
5. **Alternate enclosures**: Multiple formats (MP3, AAC, Opus) per episode
6. **Value 4 Value**: `<podcast:value>` and `<podcast:funding>` tags

## References

- [Podcast RSS 2.0 Specification](https://github.com/Podcastindex-org/podcast-namespace)
- [Apple Podcasts RSS Requirements](https://help.apple.com/itc/podcasts_connect/#/itc9267a2f12)
- [Jekyll Generators](https://jekyllrb.com/docs/plugins/generators/)
- [ruby-mp3info](https://github.com/moumar/ruby-mp3info)
- [Cast Feed Validator](https://castfeedvalidator.com/)
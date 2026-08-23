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
      # Get the absolute path to the audio directory
      audio_path = File.join(site.source, audio_dir)
      return [] unless Dir.exist?(audio_path)

      # Find all .mp3 files recursively
      mp3_files = Dir.glob(File.join(audio_path, '**', '*.mp3')).sort

      episodes = mp3_files.map do |file_path|
        # Get relative path from site source
        relative_path = file_path.sub("#{site.source}/", '')

        # Get file stats
        stat = File.stat(file_path)
        file_size = stat.size
        mtime = stat.mtime

        # Try to read companion YAML file for rich metadata
        yaml_data = read_companion_yaml(file_path)

        # Try to read ID3 tags
        id3_data = read_id3_tags(file_path)

        # Determine title: YAML > ID3 > filename
        title = yaml_data['title'] || id3_data[:title] || File.basename(file_path, '.mp3').gsub(/[-_]/, ' ').split.map(&:capitalize).join(' ')

        # Determine description: YAML > ID3 comments > empty
        description = yaml_data['description'] || id3_data[:comments] || ''

        # Determine pub_date: YAML > ID3 year > file mtime
        pub_date = parse_date(yaml_data['date']) || parse_date(id3_data[:year]) || mtime

        # Determine duration: YAML > ID3 > empty
        duration = yaml_data['duration'] || id3_data[:duration] || ''

        # Determine explicit: YAML > ID3 > config default > false
        explicit = yaml_data.key?('explicit') ? yaml_data['explicit'] : (id3_data[:explicit] || config['explicit'] || false)

        # Determine episode number: YAML > ID3 track > 0
        episode_number = yaml_data['episode'] || id3_data[:track] || 0

        # Determine season: YAML > ID3 > 1
        season = yaml_data['season'] || id3_data[:season] || 1

        # Determine episode type: YAML > default
        episode_type = yaml_data['episode_type'] || 'full'

        # Build episode metadata
        episode = {
          'file_path' => relative_path,
          'url' => build_audio_url(site, relative_path),
          'title' => title,
          'description' => description,
          'pub_date' => pub_date,
          'duration' => duration,
          'file_size' => file_size,
          'mime_type' => 'audio/mpeg',
          'guid' => build_guid(relative_path),
          'explicit' => explicit,
          'episode_number' => episode_number,
          'season' => season,
          'episode_type' => episode_type,
          'image' => yaml_data['image'] || id3_data[:image]
        }
        episode
      end

      # Sort by pub_date descending (newest first)
      episodes.sort_by { |e| e['pub_date'] }.reverse
    end

    def read_companion_yaml(file_path)
      yaml_path = file_path.sub(/\.mp3$/i, '.yml')
      return {} unless File.exist?(yaml_path)

      require 'yaml'
      YAML.load_file(yaml_path) || {}
    rescue => e
      Jekyll.logger.warn "PodcastFeedGenerator:", "Error reading companion YAML for #{file_path}: #{e.message}"
      {}
    end

    def read_id3_tags(file_path)
      require 'mp3info'
      data = {}
      Mp3Info.open(file_path) do |mp3|
        data[:title] = mp3.tag.title
        data[:artist] = mp3.tag.artist
        data[:album] = mp3.tag.album
        data[:track] = mp3.tag.tracknum
        data[:year] = mp3.tag.year
        data[:genre] = mp3.tag.genre
        data[:comments] = mp3.tag.comments
        data[:duration] = format_duration(mp3.length)
        data[:explicit] = false # Could be inferred from genre or comments

        # Try to get cover art
        if mp3.tag2 && mp3.tag2.pictures && mp3.tag2.pictures.any?
          data[:image_data] = mp3.tag2.pictures.first
        end
      end
      data
    rescue LoadError
      Jekyll.logger.warn "PodcastFeedGenerator:", "ruby-mp3info gem not available, using filename for metadata"
      {}
    rescue => e
      Jekyll.logger.warn "PodcastFeedGenerator:", "Error reading ID3 tags for #{file_path}: #{e.message}"
      {}
    end

    def parse_date(value)
      return nil if value.nil? || value.to_s.empty?
      case value
      when Time, DateTime
        value
      when Date
        value.to_time
      when String
        Time.parse(value) rescue nil
      when Integer
        # Assume year
        Time.new(value) rescue nil
      else
        nil
      end
    end

    def format_duration(seconds)
      return '' unless seconds && seconds > 0
      hours = (seconds / 3600).to_i
      minutes = ((seconds % 3600) / 60).to_i
      secs = (seconds % 60).to_i
      if hours > 0
        "%d:%02d:%02d" % [hours, minutes, secs]
      else
        "%d:%02d" % [minutes, secs]
      end
    end

    def build_audio_url(site, relative_path)
      baseurl = site.config['baseurl'] || ''
      "#{site.config['url']}#{baseurl}/#{relative_path}"
    end

    def build_guid(relative_path)
      # Stable GUID based on file path
      require 'digest'
      "urn:sha256:#{Digest::SHA256.hexdigest(relative_path)[0..31]}"
    end

    def build_feed(site, config, episodes)
      require 'builder'

      feed_config = config
      baseurl = site.config['baseurl'] || ''
      site_url = site.config['url'] || ''
      feed_url = "#{site_url}#{baseurl}/#{feed_config['feed_path'] || 'podcast.xml'}"

      xml = Builder::XmlMarkup.new(indent: 2)
      xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      xml.rss('version' => '2.0',
              'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
              'xmlns:content' => 'http://purl.org/rss/1.0/modules/content/',
              'xmlns:atom' => 'http://www.w3.org/2005/Atom') do
        xml.channel do
          # Feed-level metadata
          xml.title feed_config['title'] || site.config['title'] || 'Podcast'
          xml.link "#{site_url}#{baseurl}"
          xml.description feed_config['description'] || site.config['description'] || ''
          xml.language feed_config['language'] || 'en-us'
          xml.copyright feed_config['copyright'] || "© #{Time.now.year} #{feed_config['author'] || site.config['author']}"
          xml.docs 'http://www.rssboard.org/rss-specification'
          xml.generator 'Jekyll Podcast Feed Generator'
          xml.tag! 'atom:link', href: feed_url, rel: 'self', type: 'application/rss+xml'

          # iTunes feed-level tags
          xml.tag! 'itunes:author', feed_config['author'] || site.config['author'] || ''
          xml.tag! 'itunes:email', feed_config['author_email'] || ''
          xml.tag! 'itunes:summary', feed_config['description'] || site.config['description'] || ''
          xml.tag! 'itunes:type', 'episodic'
          xml.tag! 'itunes:explicit', feed_config['explicit'] ? 'true' : 'false'
          xml.tag! 'itunes:language', feed_config['language'] || 'en-us'

          # iTunes categories
          if feed_config['categories']
            feed_config['categories'].each do |cat|
              xml.tag! 'itunes:category', text: cat
            end
          elsif feed_config.dig('itunes', 'category')
            xml.tag! 'itunes:category', text: feed_config.dig('itunes', 'category') do
              if feed_config.dig('itunes', 'subcategory')
                xml.tag! 'itunes:category', text: feed_config.dig('itunes', 'subcategory')
              end
            end
          end

          # iTunes image (cover art)
          if feed_config['image']
            image_url = "#{site_url}#{baseurl}#{feed_config['image']}"
            xml.tag! 'itunes:image', href: image_url
          end

          # iTunes owner
          if feed_config.dig('itunes', 'owner_name') || feed_config.dig('itunes', 'owner_email')
            xml.tag! 'itunes:owner' do
              xml.tag! 'itunes:name', feed_config.dig('itunes', 'owner_name') || feed_config['author'] || ''
              xml.tag! 'itunes:email', feed_config.dig('itunes', 'owner_email') || feed_config['author_email'] || ''
            end
          end

          # iTunes keywords
          if feed_config.dig('itunes', 'keywords')
            xml.tag! 'itunes:keywords', feed_config.dig('itunes', 'keywords')
          end

          # Episodes
          episodes.each_with_index do |episode, index|
            xml.item do
              xml.title episode['title']
              xml.link episode['url']
              xml.description episode['description']
              xml.pubDate episode['pub_date'].rfc822
              xml.guid episode['guid'], isPermaLink: 'false'
              xml.enclosure url: episode['url'],
                           length: episode['file_size'].to_s,
                           type: episode['mime_type']

              # iTunes episode tags
              xml.tag! 'itunes:title', episode['title']
              xml.tag! 'itunes:summary', episode['description']
              xml.tag! 'itunes:duration', episode['duration'] unless episode['duration'].empty?
              xml.tag! 'itunes:explicit', episode['explicit'] ? 'true' : 'false'
              xml.tag! 'itunes:episode', episode['episode_number'] if episode['episode_number'] > 0
              xml.tag! 'itunes:season', episode['season'] if episode['season'] > 0
              xml.tag! 'itunes:episodeType', episode['episode_type']
              xml.tag! 'itunes:guid', episode['guid']

              # iTunes image for episode (fallback to feed image)
              if episode['image'] && episode['image'][:data]
                # Would need to save image data to a file and reference it
                # For now, use feed-level image
              end
            end
          end
        end
      end
      xml.target!
    end

    def write_feed(site, feed_xml, feed_path)
      # Write to _site/ (for local preview)
      dest_path = File.join(site.dest, feed_path)
      FileUtils.mkdir_p(File.dirname(dest_path))
      File.write(dest_path, feed_xml)

      # Write to source root (for GitHub Pages commit)
      source_path = File.join(site.source, feed_path)
      FileUtils.mkdir_p(File.dirname(source_path))
      File.write(source_path, feed_xml)

      Jekyll.logger.info "PodcastFeedGenerator:", "Generated #{feed_path} with #{feed_xml.lines.count} lines"
    end
  end
end
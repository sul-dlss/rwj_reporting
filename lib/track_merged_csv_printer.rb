require 'csv'
require 'fileutils'

###
# A class to merge the show count log data with the known show/track list
# The known tracklist is expected to be in the desired sort order, and play counts
# applied to the existing show and track number.
# The resulting CSV format: 123,5,2 "#{show_number},#{track_number},#{play_count}"
class TrackMergedCSVPrinter
  def initialize(show_counts, file_name, config = SettingsFile.new)
    @show_counts = show_counts
    @file_name = file_name
    @config = config
    create_output_directory
  end

  def print
    CSV.open(file_path, 'wb') do |csv|
      track_list_template.each do |show, track|
        csv << [show, track, normalized_show_counts[show] || 0]
      end
    end
  end

  private

    attr_reader :show_counts, :file_name, :config

    def track_list_template
      @track_list_template ||= CSV.read(config.track_list_location)
    end

    def normalized_show_number(show)
      show[/\d+/]
    end

    # The show_counts hash with can include shownums like 123a.
    # This returns a modified hash that normalizes the shownumber key.
    def normalized_show_counts
      @normalized_show_counts ||= show_counts.map do |shownum, count|
        [normalized_show_number(shownum), count]
      end.to_h
    end

    def create_output_directory
      FileUtils.makedirs(config.output_dir) unless Dir.exist?(config.output_dir)
    end

    def file_path
      File.join(config.output_dir, file_name)
    end
end

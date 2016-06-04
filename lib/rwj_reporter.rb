require 'settings_file'
require 'simple_csv_printer'
require 'track_merged_csv_printer'

class RwjReporter
  # the following class methods can be considered private
  # TODO:  these may be better as private instance methods even though they don't
  #   rely on any instance data

  def self.log_file_dir_from_settings
    require 'yaml'
    settings = YAML.load_file 'config/settings.yml'
    settings['log_file_dir']
  end

  # expects a text file with xml that contains something like:
  #  <body>1,1,21,unlimited,-1,, - Show Number 062<br />1,1,21,unlimited,-1,, - Show Number 196a<br /></body>
  #
  # where the <body> contains "lines" that end with show numbers (lines are separated by <br> tags, not necessarily line breaks).
  # the show number should be the last thing on each line.  a show "number" might contain alpha chars, is not strictly numeric,
  # and can be labeled both "Show Number" or simply "show".
  #
  # returns an array of show numbers from such a text file by finding matches for a simple regex in the text.
  # so, in the above example, the result would be ["062", "196a"]
  def self.get_show_numbers_from_log_file(fname)
    log_file_content = open(fname).read
    log_file_content.scan(/Show Number (\w+)<|show(\w+)</).flatten.compact
  end

  def self.get_filenames_for_date_range(log_file_dir, start_date_str, end_date_str)
    Dir.entries(log_file_dir).select do |fname|
      get_date_str_from_filename(fname) >= start_date_str && get_date_str_from_filename(fname) <= end_date_str
    end
  end

  def self.get_date_str_from_filename(fname)
    fname_date_regex = /\.(\d{6})\-/
    return '' unless fname.match(fname_date_regex)
    fname.match(fname_date_regex)[1]
  end

  def self.add_shownum_to_channel_count(channel_count_hash, shownum)
    channel_count_hash[shownum] =
      if channel_count_hash.key? shownum
        channel_count_hash[shownum] + 1
      else
        1
      end
  end

  # instance methods

  def initialize(start_date_str, end_date_str, log_file_dir=nil, printer_class = TrackMergedCSVPrinter)
    @log_file_dir =
      if log_file_dir
        log_file_dir
      else
        self.class.log_file_dir_from_settings
      end
    @start_date_str = start_date_str
    @end_date_str = end_date_str
    @printer_class = printer_class
  end

  def print_reports_for_dates
    channel_counts
    print_channel_counts_files
  end

  private

    attr_reader :printer_class

    def channel_counts
      self.class.get_filenames_for_date_range(@log_file_dir, @start_date_str, @end_date_str).each do |fname|
        add_shownums_to_channel_counts(self.class.get_show_numbers_from_log_file(File.join(@log_file_dir, fname)))
      end
    end

    def print_channel_counts_files
      printer_class.new(channel1_counts, file_name(1)).print
      printer_class.new(channel2_counts, file_name(2)).print
    end

    def add_shownums_to_channel_counts(shownum_array)
      self.class.add_shownum_to_channel_count(channel1_counts, shownum_array.first)
      self.class.add_shownum_to_channel_count(channel2_counts, shownum_array.last)
    end

    def channel1_counts
      @channel1_counts ||= {}
    end

    def channel2_counts
      @channel2_counts ||= {}
    end

    def file_name(channel_num)
      "#{@start_date_str}-#{@end_date_str}_channel_#{channel_num}_usage_counts.csv"
    end
end

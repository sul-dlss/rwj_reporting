class RwjReporter
  def self.print_reports_for_dates(start_date_str, end_date_str, log_file_dir=nil, output_dir=nil)
    rr = RwjReporter.new(log_file_dir)
    rr.channel_counts(start_date_str, end_date_str)
    rr.print_channel_counts_files(output_dir)
  end

  def initialize(log_file_dir=nil)
    @log_file_dir = if log_file_dir
      log_file_dir
    else
      get_log_file_dir_from_settings
    end
  end

  def self.get_log_file_dir_from_settings
    settings = YAML.load_file 'config/settings.yml'
    settings['LOG_FILE_DIR']
  end

  # expects a text file with xml that contains something like:
  #  <body>1,1,21,unlimited,-1,, - Show Number 062<br />1,1,21,unlimited,-1,, - Show Number 196a<br /></body>
  #
  # where the <body> contains "lines" that end with show numbers (lines are separated by <br> tags, not necessarily line breaks).
  # the show number should be the last thing on each line.  a show "number" might contain alpha chars, and is not strictly numeric.
  #
  # returns an array of show numbers from such a text file by finding matches for a simple regex in the text.
  # so, in the above example, the result would be ["062", "196a"]
  def self.get_show_numbers_from_log_file(fname)
    log_file_content = open(fname).read
    log_file_content.scan(/Show Number (\w+)</).flatten
  end

  def self.get_filenames_for_date_range(log_file_dir, start_date_str, end_date_str)
    return Dir.entries(log_file_dir).select { |fname| get_date_str_from_filename(fname) >= start_date_str && get_date_str_from_filename(fname) <= end_date_str }
  end

  # the following class methods can be considered private

  def self.get_date_str_from_filename(fname)
    fname_date_regex = /\.(\d{6})\-/
    return '' unless fname.match(fname_date_regex)
    return fname.match(fname_date_regex)[1]
  end

  def self.add_shownum_to_channel_count(channel_count_hash, shownum)
    channel_count_hash[shownum] = if channel_count_hash.key? shownum
      channel_count_hash[shownum] + 1
    else
      1
    end
  end

  def channel_counts(start_date_str, end_date_str)
    @start_date_str = start_date_str
    @end_date_str = end_date_str
    self.class.get_filenames_for_date_range(@log_file_dir, start_date_str, end_date_str).each { |fname|  
      add_shownums_to_channel_counts(self.class.get_show_numbers_from_log_file(File.join(@log_file_dir, fname)))
    }
  end

  def print_channel_counts_files(output_dir=nil)
    File.write(File.join(output_dir, file_name(1)), channel1_counts.sort.map { |count_pair| count_pair.join(',') }.join("\n"))
    File.write(File.join(output_dir, file_name(2)), channel2_counts.sort.map { |count_pair| count_pair.join(',') }.join("\n"))
  end

  def file_name(channel_num)
    "#{@start_date_str}-#{@end_date_str}_channel_#{channel_num}_usage_counts.csv"
  end

  private

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
end
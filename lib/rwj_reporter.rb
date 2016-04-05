class RwjReporter

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

  private
  def self.get_date_str_from_filename(fname)
    fname_date_regex = /\.(\d{6})\-/
    return '' unless fname.match(fname_date_regex)
    return fname.match(fname_date_regex)[1]
  end
end

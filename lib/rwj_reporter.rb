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
end

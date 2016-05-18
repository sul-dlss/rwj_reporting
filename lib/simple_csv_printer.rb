require 'csv'
require 'fileutils'

###
# A class to write show nubmers and counts to a CSV file.
# This is not currently being used by RWJReporter and has
# been replaced by a different CSVPrinter class.
class SimpleCSVPrinter
  def initialize(show_counts, file_name, config = SettingsFile.new)
    @show_counts = show_counts
    @file_name = file_name
    @config = config
    create_output_directory
  end

  def print
    CSV.open(file_path, 'wb') do |csv|
      show_counts.sort.each do |show_count|
        csv << show_count
      end
    end
  end

  private

    attr_reader :show_counts, :file_name, :config

    def create_output_directory
      FileUtils.makedirs(config.output_dir) unless Dir.exist?(config.output_dir)
    end

    def file_path
      File.join(config.output_dir, file_name)
    end
end

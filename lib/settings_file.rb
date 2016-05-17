require 'yaml'

# A class to model and inject configuration
# dependencies into classes that need this information
class SettingsFile
  def initialize(file_path = 'config/settings.yml')
    @file_path = file_path
  end

  # This is not currently in use, but I am leaving it here
  # as an example of the pattern we're trying to establish
  # def log_file_dir
  #   settings_file['log_file_dir']
  # end

  def output_dir
    settings_file['output_dir']
  end

  private

    attr_reader :file_path

    def settings_file
      @settings_file ||= YAML.load_file(file_path)
    end
end

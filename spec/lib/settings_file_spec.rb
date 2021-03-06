require 'spec_helper'

describe SettingsFile do
  describe '#log_file_dir' do
    pending 'is configured' do
      expect(subject.log_file_dir).to eq '.'
    end
  end

  describe '#output_dir' do
    it 'is configured' do
      expect(subject.output_dir).to eq 'tmp'
    end
  end

  describe '#track_list_location' do
    it 'is configured' do
      expect(subject.track_list_location).to eq 'data/track-template.csv'
    end
  end
end

require 'spec_helper'

describe SimpleCSVPrinter do
  let(:show_counts) { { '200' => '3', '100' => '5' } }
  let(:file_name) { 'file123.csv' }
  let(:temp_file_path) { 'tmp/file123.csv' }
  subject { described_class.new(show_counts, file_name) }

  after(:all) do
    # cannot use temp_file_path defined in let here
    File.delete('tmp/file123.csv') if File.exist?('tmp/file123.csv')
  end

  describe 'initialization' do
    after { Dir.delete('tmp/tmp2') if Dir.exist?('tmp/tmp2') }

    it 'creates the directories if needed' do
      config = double('Configuration', output_dir: 'tmp/tmp2')
      expect(Dir.exist?('tmp/tmp2')).to be false

      described_class.new(show_counts, file_name, config)
      expect(Dir.exist?('tmp/tmp2')).to be true
    end
  end

  describe '#print' do
    before { subject.print }
    let(:csv_data) { CSV.read(temp_file_path) }
    it 'prints out a CSV file with the given show counts' do
      expect(csv_data).to be_an Array
      expect(csv_data.length).to eq 2
    end

    it 'sorts the data based on show number' do
      expect(csv_data[0][0]).to eq '100'
      expect(csv_data[1][0]).to eq '200'
    end

    it 'includes show counts' do
      expect(csv_data[0].length).to eq 2
      expect(csv_data[0][1]).to eq '5'

      expect(csv_data[1].length).to eq 2
      expect(csv_data[1][1]).to eq '3'
    end
  end

  describe 'File Path' do
    it 'includes the configured output directory' do
      expect(subject.send(:file_path)).to match(/^tmp\//)
    end

    it 'includes the file name' do
      expect(subject.send(:file_path)).to match(/\/#{file_name}$/)
    end

    it 'allows for a configured output directory to be injected' do
      config = double('Configuration', output_dir: 'some_other_dir')
      printer = described_class.new(show_counts, file_name, config)
      expect(printer.send(:file_path)).to match(/^some_other_dir\//)
    end
  end
end

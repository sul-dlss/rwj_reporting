require 'spec_helper'

describe TrackMergedCSVPrinter do
  let(:show_counts) { { '200' => '10', '150' => '17' } }
  let(:file_name) { 'abc123.csv' }
  subject { described_class.new(show_counts, file_name) }

  after(:all) do
    # cannot use temp_file_path defined in let here
    File.delete('tmp/abc123.csv') if File.exist?('tmp/abc123.csv')
  end

  describe '#print' do
    let(:csv_data) { CSV.open('tmp/abc123.csv').read }
    before do
      allow(subject).to receive(:track_list_template).and_return(
        [
          ['150', '1'], ['150', '2'], ['150', '3'], ['150', '4'],
          ['200', '1'], ['200', '2'], ['200', '3'], ['200', '4'], ['200', '5']
        ]
      )
    end
    it 'repeats all show counts for each track in the track template' do
      subject.print
      expect(csv_data).to eq(
        [
          ['150', '1', '17'], ['150', '2', '17'], ['150', '3', '17'], ['150', '4', '17'],
          ['200', '1', '10'], ['200', '2', '10'], ['200', '3', '10'], ['200', '4', '10'], ['200', '5', '10']
        ]
      )
    end

    context 'when show a show has no plays' do
      let(:show_counts) { { '200' => '10' } }

      it 'a zero is added explicitly' do
        subject.print
        expect(csv_data).to eq(
          [
            ['150', '1', '0'], ['150', '2', '0'], ['150', '3', '0'], ['150', '4', '0'],
            ['200', '1', '10'], ['200', '2', '10'], ['200', '3', '10'], ['200', '4', '10'], ['200', '5', '10']
          ]
        )
      end
    end

    context 'when a show number includes a letter' do
      let(:show_counts) { { '200a' => '10', '150b' => '17' } }

      it 'normalizes the show number to strip out any letters' do
        subject.print
        expect(csv_data).to eq(
          [
            ['150', '1', '17'], ['150', '2', '17'], ['150', '3', '17'], ['150', '4', '17'],
            ['200', '1', '10'], ['200', '2', '10'], ['200', '3', '10'], ['200', '4', '10'], ['200', '5', '10']
          ]
        )
      end
    end
  end

  describe '#track_list_template' do
    it 'reads the configured track-template and parses as CSV' do
      track_list_template = subject.send(:track_list_template)
      expect(track_list_template).to be_an Array
      expect(track_list_template.length).to be > 100
      expect(track_list_template.first.length).to eq 2
      expect(track_list_template.last.length).to eq 2
    end
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

  describe '#show_count_key' do
    it 'normalizes the show number to stip out any letters' do
      expect(subject.send(:normalized_show_number, 'abc414def')).to eq '414'
    end
  end

  describe '#normalized_show_counts' do
    let(:show_counts) { { nil => 1, '123' => 4 } }
    it 'excludes show counts without a show number' do
      expect(subject.send(:normalized_show_counts)).to eq('123' => 4)
    end
  end
end

describe 'RwjReporter' do
  FIXTURE_DIR = 'spec/fixtures'.freeze
  OUTPUT_DIR = 'tmp'.freeze

  context '.add_shownum_to_channel_count' do
    it 'adds new key with value 1 when shownum not already present' do
      existing_hash = {}
      RwjReporter.add_shownum_to_channel_count(existing_hash, '055')
      expect(existing_hash).to eq('055' => 1)
    end
    it 'increments counter value when shownum is present' do
      existing_hash = { '666' => 2 }
      RwjReporter.add_shownum_to_channel_count(existing_hash, '666')
      expect(existing_hash).to eq('666' => 3)
    end
  end

  context '.get_show_numbers_from_log_file' do
    it 'returns an array of 2 show numbers' do
      fname = "#{FIXTURE_DIR}/streamguys.160201- 101.log"
      expect(RwjReporter.get_show_numbers_from_log_file(fname)).to eq ['062', '196a']
    end

    it 'handles show numbers formatted as "show123a" as well as "Show Number 123a"' do
      fname = "#{FIXTURE_DIR}/streamguys.160303-1101.log"
      expect(RwjReporter.get_show_numbers_from_log_file(fname)).to eq ['181a', '101']
    end
  end

  context '.get_filenames_for_date_range' do
    let(:filename_list) do
      log_file_dir = FIXTURE_DIR
      start_date_str = '160228' # 2/28/2016
      end_date_str = '160303' # 3/3/2016
      RwjReporter.get_filenames_for_date_range(log_file_dir, start_date_str, end_date_str)
    end
    it 'returns an array of the expected length for the given date range' do
      expect(filename_list.length).to eq(120)
    end
    it 'contains expected values' do
      expect(filename_list).to include('streamguys.160228- 001.log', 'streamguys.160229- 901.log', 'streamguys.160303-2301.log')
    end
  end

  it 'can get log_file_dir from the default config file' do
    expect(RwjReporter.log_file_dir_from_settings).to eq '.'
  end

  context '#print_reports_for_dates' do
    let(:rr) { RwjReporter.new('160301', '160303', FIXTURE_DIR) }
    let(:fname_pfx) { '160301-160303_channel_' }
    let(:channel1_output_array) { File.open(File.join(OUTPUT_DIR, "#{fname_pfx}1_usage_counts.csv")).readlines }
    let(:channel2_output_array) { File.open(File.join(OUTPUT_DIR, "#{fname_pfx}2_usage_counts.csv")).readlines }
    context 'default OUTPUT_DIR' do
      it 'takes output_dir from settings if no param' do
        # covered by other tests, as print_report_for_dates is called w/o arg
      end
      it 'file contains lines of show number comma count' do
        rr.print_reports_for_dates
        line = channel1_output_array.first
        shownum, tracknum, count = line.split(',')
        expect(shownum).to match(/^\d{1,3}[a-z]?$/)
        expect(tracknum).to match(/^\d{1,2}?$/)
        expect(count).to match(/^\d{1}/)
      end
    end
  end

  context 'private methods' do
    context '#add_shownums_to_channel_counts' do
      it 'increments the counts for show numbers for each channel' do
        rr = RwjReporter.new('start_date', 'end_date', 'log_dir')
        rr.send(:add_shownums_to_channel_counts, ['152a', '001b'])
        rr.send(:add_shownums_to_channel_counts, ['153a', '001b'])
        expect(rr.send(:channel1_counts)['152a']).to eq(1)
        expect(rr.send(:channel2_counts)['001b']).to eq(2)
        expect(rr.send(:channel1_counts)['153a']).to eq(1)
      end
    end

    context '#channel_counts' do
      it 'gets the right channel counts for a set of log files in the given date range' do
        rr = RwjReporter.new('160228', '160303', FIXTURE_DIR)
        rr.send(:channel_counts)
        expect(rr.send(:channel1_counts)).to include("115b" => 1, "019a" => 1, "260" => 1, "101" => 1, "350" => 1, "336" => 1)
        expect(rr.send(:channel2_counts)).to include("140" => 1, "118" => 1, "348" => 1, "250" => 1)
      end
    end

    context '#print_channel_counts_files' do
      before(:context) do
        RwjReporter.new('160228', '160303', FIXTURE_DIR).print_reports_for_dates
      end
      let(:channel1_data_array) { File.open(File.join(OUTPUT_DIR, '160228-160303_channel_1_usage_counts.csv')).readlines }
      let(:channel2_data_array) { File.open(File.join(OUTPUT_DIR, '160228-160303_channel_2_usage_counts.csv')).readlines }
      it 'file contains lines of show number comma count' do
        line = channel1_data_array.first
        shownum, tracknum, count = line.split(',')
        expect(shownum).to match(/^\d{1,3}[a-z]?$/)
        expect(tracknum).to match(/^\d{1,2}?$/)
        expect(count).to match(/^\d{1}/)
      end
    end
  end
end

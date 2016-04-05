require 'rwj_reporter'

describe 'RwjReporter' do
  context '.get_show_numbers_from_log_file' do
    it 'returns an array of 2 show numbers' do
      fname = 'spec/fixtures/streamguys.160201- 101.log'
      expect(RwjReporter.get_show_numbers_from_log_file(fname)).to eq ['062', '196a']
    end
  end

  context '.get_files_for_date_range' do
    let(:filename_list) do
      log_file_dir = 'spec/fixtures/'
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

  context '.add_shownum_to_channel_count' do
    it 'adds new key with value 1 when shownum not already present' do
      existing_hash = {}
      RwjReporter.add_shownum_to_channel_count(existing_hash, '055')
      expect(existing_hash).to eq({'055' => 1})
    end
    it 'increments counter value when shownum is present' do
      existing_hash = {'666' => 2}
      RwjReporter.add_shownum_to_channel_count(existing_hash, '666')
      expect(existing_hash).to eq({'666' => 3})
    end
  end

  context '#add_shownums_to_channel_counts' do
    it 'increments the counts for show numbers for each channel' do
      rr = RwjReporter.new
      rr.send(:add_shownums_to_channel_counts, ['152a', '001b'])
      rr.send(:add_shownums_to_channel_counts, ['153a', '001b'])
      expect(rr.send(:channel1_counts)['152a']).to eq(1)
      expect(rr.send(:channel2_counts)['001b']).to eq(2)
      expect(rr.send(:channel1_counts)['153a']).to eq(1)
    end
  end

  context '#channel_counts' do
    it 'gets the right channel counts for a set of log files in the given date range' do
      rr = RwjReporter.new
      rr.channel_counts('160228', '160303')
      expect(rr.send(:channel1_counts)).to include("115b"=>1, "019a"=>1, "260"=>1, "101"=>1, "350"=>1, "336"=>1)
      expect(rr.send(:channel2_counts)).to include("140"=>1, "118"=>1, "348"=>1, "250"=>1)
    end
  end

  context '#print_channel_counts_files' do
    before(:context) {
      rr = RwjReporter.new
      rr.channel_counts('160228', '160303')
      rr.print_channel_counts_files
    }
    let (:channel1_data_array) { File.open('160228-160303_channel_1_usage_counts.csv').readlines } 
    let (:channel2_data_array) { File.open('160228-160303_channel_2_usage_counts.csv').readlines } 
    it 'each channel file is sorted by show number' do
      expect(channel1_data_array).to eq channel1_data_array.sort
      expect(channel2_data_array).to eq channel2_data_array.sort
    end
    it 'file contains lines of show number comma count' do
      line = channel1_data_array.first
      shownum, count = line.split(',')
      expect(shownum).to match(/^\d{3}[a-z]?$/)
      expect(count.to_i).to be >= 1
    end
  end
end

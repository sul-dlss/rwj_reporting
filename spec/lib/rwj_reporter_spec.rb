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
end

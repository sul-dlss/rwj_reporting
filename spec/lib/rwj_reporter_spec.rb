require 'rwj_reporter'

describe 'RwjReporter' do
  context '.get_show_numbers_from_log_file' do
    it 'returns an array of 2 show numbers' do
      fname = 'spec/fixtures/streamguys.160201- 101.log'
      expect(RwjReporter.get_show_numbers_from_log_file(fname)).to eq ['062', '196a']
    end
  end
end

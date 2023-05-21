require 'spec_helper'

describe Pipeline do
  describe '#configure' do
    it 'honors account_key=' do
      Pipeline.configure {|c| c.account_key = 'xyz' }
      expect(Pipeline::Resource.account_key).to eq 'xyz'
    end

    it 'honors api_key=' do
      Pipeline.configure {|c| c.api_key = 'xyz' }
      expect(Pipeline::Resource.api_key).to eq 'xyz'
    end

    it 'honors app_key=' do
      Pipeline.configure {|c| c.app_key = 'xyz' }
      expect(Pipeline::Resource.app_key).to eq 'xyz'
    end

    it 'honors site=' do
      Pipeline.configure {|c| c.site = 'http://localhost:3000' }
      expect(Pipeline::Resource.site.to_s).to eq 'http://localhost:3000'
    end
  end
end

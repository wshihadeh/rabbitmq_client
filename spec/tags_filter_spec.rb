# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::TagsFilter do
  describe '.tags' do
    context 'using default values' do
      it 'return nil as default' do
        expect(RabbitmqClient::TagsFilter.tags).to eq(nil)
      end
    end

    context 'using RequestStore as global store' do
      let(:global_store) { double('Store') }
      before do
        RabbitmqClient.config.global_store = global_store
      end

      after do
        RabbitmqClient.config.global_store = nil
      end

      it 'return empty hash as default' do
        allow(global_store).to receive(:store).and_return({})
        expect(RabbitmqClient::TagsFilter.tags).to eq({})
      end

      it 'fillter store keys and only return whitelisted keys' do
        allow(global_store).to receive(:store).and_return(
          not_allowed: 'test',
          'x-request-id' => '1010'
        )
        expect(RabbitmqClient::TagsFilter.tags).to eq('x-request-id' => '1010')
      end
    end
  end
end

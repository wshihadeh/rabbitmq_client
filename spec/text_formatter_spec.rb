# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::TextFormatter do
  subject { described_class.new }
  let(:message) { 'Test loG message' }
  let(:global_store) { double('Store') }
  let(:time) { Time.now }
  let(:formated_time) { time.strftime('%Y-%m-%dT%H:%M:%S.%6N ') }

  before do
    RabbitmqClient.config.global_store = global_store
  end

  after do
    RabbitmqClient.config.global_store = nil
  end

  describe '.call' do
    it 'formatt the log message' do
      allow(global_store).to receive(:store).and_return({})
      log_line = subject.call('DEBUG', time, nil, message)
      expect(log_line).to match(
        /D, \[#{formated_time}#\d+\] DEBUG -- : #{message}/
      )
    end

    it 'map int severity to string' do
      allow(global_store).to receive(:store).and_return({})
      log_line = subject.call(0, time, nil, message)
      expect(log_line).to match(
        /D, \[#{formated_time}#\d+\] DEBUG -- : #{message}/
      )
    end

    it 'add tags to the log message' do
      allow(global_store).to receive(:store).and_return('x-request-id': '10')
      log_line = subject.call(1, time, nil, message)
      expect(log_line).to match(
        /I, \[#{formated_time}#\d+\]  INFO -- : \[x-request-id: 10\] #{message}/
      )
    end
  end
end

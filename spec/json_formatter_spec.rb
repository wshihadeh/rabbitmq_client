# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::JsonFormatter do
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
      json_log = JSON.parse(log_line[0...-1])
      expect(json_log).to eq(
        'level' => 'DEBUG',
        'message' => 'Test loG message',
        'timestamp' => formated_time
      )
    end

    it 'add tags to the log message' do
      allow(global_store).to receive(:store).and_return('x-request-id': '10')
      log_line = subject.call('DEBUG', time, nil, message)
      json_log = JSON.parse(log_line[0...-1])
      expect(json_log).to eq(
        'level' => 'DEBUG',
        'message' => 'Test loG message',
        'timestamp' => formated_time,
        'x-request-id' => '10'
      )
    end
  end
end

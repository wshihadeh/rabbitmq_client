# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::PlainLogSubscriber do
  class DummyEvent < ActiveSupport::Notifications::Event
    def initialize(event_type, payload = {})
      super(event_type, Time.now, Time.now, 1, payload)
    end
  end

  let(:error) { double('error') }

  before do
    allow(error).to receive(:message).and_return('error')
  end

  describe '#publisher_created' do
    it 'send logger a debug message' do
      msg = 'The RabbitmqClient publisher is '\
      'created with the follwong configs {}'
      expect(subject.logger).to receive(:debug).with(msg)
      subject.publisher_created(DummyEvent.new(
                                  'publisher_created.rabbitmq_client',
                                  {}
                                ))
    end
  end

  describe '#network_error' do
    let(:payload) { { error: error, options: { exchange_name: 'exchange' } } }
    it 'send logger a error message' do
      expect(subject.logger).to receive(:error)
        .with('Failed to publish a message (error) to exchange (exchange)')
      subject.network_error(DummyEvent.new(
                              'network_error.rabbitmq_client',
                              payload
                            ))
    end
  end
  describe '#overriding_configs' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug)
        .with('Overriding the follwing configs for the created publisher {}')
      subject.overriding_configs(DummyEvent.new(
                                   'overriding_configs.rabbitmq_client',
                                   {}
                                 ))
    end
  end
  describe '#publishing_message' do
    it 'send logger a debug message' do
      msg = 'Start>> Publishing a new message '\
      '(message_id: undefined ) to the exchange (undefined)'
      expect(subject.logger).to receive(:debug).with(msg)
      subject.publishing_message(DummyEvent.new(
                                   'publishing_message.rabbitmq_client',
                                   {}
                                 ))
    end
  end
  describe '#published_message' do
    it 'send logger a debug message' do
      msg = '<<DONE Published a message to the '\
            'exchange (undefined) with message_id: undefined'
      expect(subject.logger).to receive(:info).with(msg)
      subject.published_message(DummyEvent.new(
                                  'published_message.rabbitmq_client',
                                  {}
                                ))
    end
  end
  describe '#confirming_message' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug)
        .with('Start>> confirming a message (message_id: undefined)')
      subject.confirming_message(DummyEvent.new(
                                   'confirming_message.rabbitmq_client',
                                   {}
                                 ))
    end
  end
  describe '#message_confirmed' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug)
        .with('<<DONE confirmed a message (message_id: undefined) Successfuly')
      subject.message_confirmed(DummyEvent.new(
                                  'message_confirmed.rabbitmq_client',
                                  {}
                                ))
    end
  end
  describe '#exhange_not_found' do
    let(:payload) { { name: 'exchange' } }
    it 'send logger a error message' do
      expect(subject.logger).to receive(:error)
        .with('The Exchange \'exchange\' cannot be found')
      subject.exhange_not_found(DummyEvent.new(
                                  'exhange_not_found.rabbitmq_client',
                                  payload
                                ))
    end
  end
  describe '#created_exhange' do
    let(:payload) { { name: 'exchange' } }
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug)
        .with('The exchange exchange is created successfuly')
      subject.created_exhange(DummyEvent.new(
                                'created_exhange.rabbitmq_client',
                                payload
                              ))
    end
  end
end

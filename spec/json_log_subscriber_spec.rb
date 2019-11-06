# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::JsonLogSubscriber do
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
      expect(subject.logger).to receive(:debug).with(
        action: 'publisher_created',
        message: 'The RabbitmqClient publisher is created',
        publisher_configs: {},
        source: 'rabbitmq_client'
      )
      subject.publisher_created(DummyEvent.new(
                                  'publisher_created.rabbitmq_client',
                                  {}
                                ))
    end
  end

  describe '#network_error' do
    let(:payload) { { error: error, options: { exchange_name: 'exchange' } } }
    it 'send logger a error message' do
      expect(subject.logger).to receive(:error).with(
        action: 'network_error',
        error_message: 'error',
        exchange_name: 'undefined',
        message: 'Failed to publish a message',
        message_id: 'undefined', source: 'rabbitmq_client'
      )
      subject.network_error(
        DummyEvent.new('network_error.rabbitmq_client', payload)
      )
    end
  end
  describe '#overriding_configs' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug).with(
        action: 'overriding_configs',
        message: 'Overriding publisher configs',
        publisher_configs: {},
        source: 'rabbitmq_client'
      )
      subject.overriding_configs(
        DummyEvent.new('overriding_configs.rabbitmq_client', {})
      )
    end
  end
  describe '#publishing_message' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug).with(
        action: 'publishing_message',
        exchange_name: 'undefined',
        message: 'Publishing a new message',
        message_id: 'undefined',
        source: 'rabbitmq_client'
      )
      subject.publishing_message(
        DummyEvent.new('publishing_message.rabbitmq_client', {})
      )
    end
  end
  describe '#published_message' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:info).with(
        action: 'published_message',
        exchange_name: 'undefined',
        message: 'Published a message',
        message_id: 'undefined',
        source: 'rabbitmq_client'
      )
      subject.published_message(
        DummyEvent.new('published_message.rabbitmq_client', {})
      )
    end
  end
  describe '#confirming_message' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug).with(
        action: 'confirming_message',
        exchange_name: 'undefined',
        message: 'Confirming a message',
        message_id: 'undefined',
        source: 'rabbitmq_client'
      )
      subject.confirming_message(
        DummyEvent.new('confirming_message.rabbitmq_client', {})
      )
    end
  end
  describe '#message_confirmed' do
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug).with(
        action: 'message_confirmed',
        exchange_name: 'undefined',
        message: 'Confirmed a message',
        message_id: 'undefined',
        source: 'rabbitmq_client'
      )
      subject.message_confirmed(
        DummyEvent.new('message_confirmed.rabbitmq_client', {})
      )
    end
  end
  describe '#exhange_not_found' do
    let(:payload) { { name: 'exchange' } }
    it 'send logger a error message' do
      expect(subject.logger).to receive(:error).with(
        action: 'exhange_not_found',
        exchange_name: 'exchange',
        message: 'Exhange Not Found',
        source: 'rabbitmq_client'
      )
      subject.exhange_not_found(
        DummyEvent.new('exhange_not_found.rabbitmq_client', payload)
      )
    end
  end
  describe '#created_exhange' do
    let(:payload) { { name: 'exchange' } }
    it 'send logger a debug message' do
      expect(subject.logger).to receive(:debug).with(
        action: 'created_exhange',
        exchange_name: 'exchange',
        message: 'Exhange is created successfuly',
        source: 'rabbitmq_client'
      )
      subject.created_exhange(
        DummyEvent.new('created_exhange.rabbitmq_client', payload)
      )
    end
  end
end

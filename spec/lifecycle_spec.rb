# frozen_string_literal: true

require 'spec_helper'
require_relative 'support/dummy_rabbitmq_client_plugin'

describe RabbitmqClient::Lifecycle do
  subject { described_class.new }

  let(:callback) { ->(*_args) {} }
  let(:arguments) { [1, 2] }
  let(:behavior) { double(Object, before!: nil, after!: nil, inside!: nil) }
  let(:wrapped_block) { proc { behavior.inside! } }

  describe 'before callbacks' do
    before do
      subject.before(:publish, &callback)
    end

    it 'executes before wrapped block' do
      expect(callback).to receive(:call).with(*arguments).ordered
      expect(behavior).to receive(:inside!).ordered
      subject.run_callbacks :publish, *arguments, &wrapped_block
    end
  end

  describe 'after callbacks' do
    before do
      subject.after(:publish, &callback)
    end

    it 'executes after wrapped block' do
      expect(behavior).to receive(:inside!).ordered
      expect(callback).to receive(:call).with(*arguments).ordered
      subject.run_callbacks :publish, *arguments, &wrapped_block
    end
  end

  it 'raises if callback is executed with wrong number of parameters' do
    subject.before(:publish, &callback)
    expect do
      subject.run_callbacks(:publish, 1, 2, 3)
    end.to raise_error(ArgumentError, /2 parameter/)
  end

  it 'raises for unsupported events' do
    expect do
      subject.before(:execute, &callback)
    end.to raise_error(
      RabbitmqClient::InvalidCallback,
      /Unknown callback/
    )
  end

  describe '#callbacks' do
    before do
      RabbitmqClient.instance_variable_set(:@lifecycle, nil)
      RabbitmqClient.configure { |x| x[:plugins] << DummyRabbitmqClientPlugin }
    end

    after do
      RabbitmqClient.configure { |x| x[:plugins] = [] }
      RabbitmqClient.instance_variable_set(:@lifecycle, nil)
    end

    it 'load plugin callbacks' do
      callbacks = RabbitmqClient.lifecycle.callbacks
      first_callback = callbacks.values.first
      last_callback = callbacks.values.last

      expect(callbacks.keys).to eq [:publish]
      expect(first_callback).to be_kind_of(RabbitmqClient::Callback)
      expect(first_callback.instance_variable_get(:@before).count).to eq 1
      expect(first_callback.instance_variable_get(:@after).count).to eq 1
      expect(last_callback.instance_variable_get(:@before).count).to eq 1
      expect(last_callback.instance_variable_get(:@after).count).to eq 1
    end
  end
end

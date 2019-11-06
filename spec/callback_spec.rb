# frozen_string_literal: true

require 'spec_helper'
require_relative 'support/dummy_rabbitmq_client_plugin'

describe RabbitmqClient::Callback do
  subject { described_class.new }

  let(:callback) { ->(*_args) {} }

  it 'initialize with emprty events' do
    expect(subject.instance_variable_get(:@before).count).to eq 0
    expect(subject.instance_variable_get(:@after).count).to eq 0
  end

  it 'raises for unsupported events' do
    expect do
      subject.add(:execute, &callback)
    end.to raise_error(
      RabbitmqClient::InvalidCallback, /Invalid callback type: execute/
    )
  end

  it 'add before and after events' do
    expect { subject.add(:before, &callback) }.not_to raise_error
    expect { subject.add(:after, &callback) }.not_to raise_error

    expect(subject.instance_variable_get(:@before).count).to eq 1
    expect(subject.instance_variable_get(:@after).count).to eq 1
  end
end

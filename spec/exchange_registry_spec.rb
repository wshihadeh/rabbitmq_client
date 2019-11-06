# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::ExchangeRegistry do
  let(:registry) { described_class.new }

  let(:exchange_name) { 'tmp_exchange' }
  let(:exchange_type) { 'test' }
  let(:exchange_opt) { { opt: false } }

  it 'initialize with emprty registry' do
    expect(registry.instance_variable_get(:@exchanges)).to be_empty
  end

  it 'add and find exchanges' do
    expect do
      registry.add(exchange_name, exchange_type, exchange_opt)
    end.not_to raise_error

    exchange = registry.find(exchange_name)
    expect(exchange.name).to eq exchange_name
    expect(exchange.type).to eq exchange_type
    expect(exchange.options).to eq exchange_opt
  end

  it 'raise error for unknown exchanges' do
    expect do
      registry.find(exchange_name)
    end.to raise_error(described_class::ExchangeNotFound)
  end
end

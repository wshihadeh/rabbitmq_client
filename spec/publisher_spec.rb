# frozen_string_literal: true

require 'spec_helper'

describe RabbitmqClient::Publisher do
  describe '#initialize' do
    context 'no configs is passed' do
      let(:publisher) { described_class.new }
      let(:default_session_params) do
        { threaded: false, automatically_recover: false, heartbeat: 0 }
      end

      it 'create publisher with default values' do
        expect(
          publisher.instance_variable_get(:@session_params)
        ).to eq default_session_params
      end
    end

    context 'configs is passed' do
      let(:session_params) do
        { session_params: {
          threaded: true,
          automatically_recover: true,
          heartbeat_publisher: 10
        } }
      end

      let(:publisher) { described_class.new(session_params) }
      let(:expected) do
        { automatically_recover: false, heartbeat: 10,
          heartbeat_publisher: 10, threaded: false }
      end

      it 'always overwrites automatically_recover and threaded' do
        expect(publisher.instance_variable_get(:@session_params)).to eq expected
      end

      it 'use :heartbeat_publisher value for :heartbeat' do
        expect(
          publisher
            .instance_variable_get(:@session_params)[:heartbeat]
        ).to eq expected[:heartbeat_publisher]
        expect(
          publisher
            .instance_variable_get(:@session_params)[:heartbeat_publisher]
        ).to eq expected[:heartbeat_publisher]
      end
    end
  end

  describe '#publish' do
    let(:bunny_session) { double('bunny_session') }
    let(:bunny_channel) { double('bunny_channel') }
    let(:exchange_name) { 'exchange' }
    let(:exchange) { double('exchange') }
    let(:confirmed) { true }

    before do
      allow(Bunny).to receive(:new).and_return(bunny_session)
      allow(bunny_session).to receive(:start)
      allow(bunny_session).to receive(:create_channel)
        .and_return(bunny_channel)
      allow(bunny_channel).to receive(:confirm_select)
      allow(exchange).to receive(:create).and_return(exchange)
      allow(exchange).to receive(:publish)
      allow(exchange).to receive(:name).and_return('exchange')
      allow(bunny_channel).to receive(:wait_for_confirms)
        .and_return(confirmed)
      allow(bunny_channel).to receive(:close)
    end

    context 'with minimum config' do
      let(:publisher) { described_class.new }
      it {
        expect(publisher.publish({},
                                 exchange_name: exchange_name)).to be_nil
      }
    end

    context 'when confirmation fail' do
      let(:exchange_registry) { double('exchange_registry') }
      let(:publisher) do
        described_class.new(exchange_registry: exchange_registry)
      end

      before do
        expect(bunny_channel).to receive(:wait_for_confirms).and_return(false)
        allow(bunny_channel).to receive(:nacked_set).and_return(1)
        allow(bunny_channel).to receive(:unconfirmed_set).and_return(2)
        allow(exchange_registry).to receive(:find).and_return(exchange)
      end

      it 'raises error' do
        expect do
          publisher.publish('message',
                            message_id: 'abc',
                            exchange_name: exchange_name)
        end.to raise_error(
          RabbitmqClient::MessagePublisher::ConfirmationFailed
        )
      end
    end

    context 'when exchange is not defined' do
      let(:exchange_registry) { RabbitmqClient::ExchangeRegistry.new }
      let(:publisher) do
        described_class.new(exchange_registry: exchange_registry)
      end
      let(:type) { 'test' }
      let(:options) { {} }

      before do
        exchange_registry.add(exchange_name, type, options)
        allow(Bunny::Exchange).to receive(:new).and_return(exchange)
      end

      it 'defines exchange' do
        publisher.publish('message',
                          message_id: 'abc',
                          exchange_name: exchange_name)
        expect(
          Bunny::Exchange
        ).to have_received(:new)
          .with(bunny_channel, type, exchange_name, options)
      end
    end

    context 'when error raised' do
      let(:error) { StandardError.new('network_error') }
      let(:exchange_registry) { double('exchange_registry') }
      let(:publisher) do
        described_class.new(exchange_registry: exchange_registry)
      end

      before do
        allow(exchange_registry).to receive(:find).and_return(exchange)
        expect(bunny_channel).to receive(:wait_for_confirms).and_raise(error)
      end

      it 'raise an error' do
        expect do
          publisher.publish('message',
                            message_id: 'abc',
                            exchange_name: exchange_name)
        end.to raise_error(error)
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe RabbitmqClient do
  it 'has a version number' do
    expect(RabbitmqClient::VERSION).not_to be nil
  end

  describe '.add_exchange' do
    let(:name) { 'exchange' }
    let(:type) { 'test_exchange' }

    it 'add exchange to the registry' do
      registry = RabbitmqClient.instance_variable_get(:@exchange_registry)

      expect do
        registry.find(name)
      end.to raise_error(
        RabbitmqClient::ExchangeRegistry::ExchangeNotFound
      )
      RabbitmqClient.add_exchange(name, type {})
      exchange = registry.find(name)

      expect(exchange.name).to eq(name)
      expect(exchange.type).to eq(type)
      expect(exchange.options).to eq({})
    end
  end

  describe '.publish' do
    let(:publisher) { double('Publisher') }
    let(:options) { { headers: { store: { uuid: '123456789' } } } }

    before do
      allow(RabbitmqClient::Publisher).to receive(:new).and_return(publisher)
    end

    it 'execute the publish callbacks with the mutated headers' do
      expect(publisher).to receive(:publish).with('message', options)
      RabbitmqClient.publish('message', options)
    end
  end

  describe '.lifecycle' do
    it 'return a RabbitmqClient::Lifecycle instance' do
      expect(RabbitmqClient.lifecycle).to be_kind_of(RabbitmqClient::Lifecycle)
    end
  end

  describe '.logger' do
    context 'with default settings' do
      before do
        RabbitmqClient.instance_variable_set(:@logger, nil)
      end
      it 'return a STDOUT logger' do
        logger = RabbitmqClient.logger
        logdev = logger.instance_variable_get(:@logdev)
        dev = logdev.instance_variable_get(:@dev)
        expect(logger).to be_kind_of(Logger)
        expect(logger.level).to eq(1)
        expect(dev.inspect).to eq('#<IO:<STDOUT>>')
      end
    end
    context 'with custome settings' do
      let(:logger_configs) do
        {
          logs_format: 'plain',
          logs_to_stdout: false,
          logs_level: :debug,
          logs_filename: 'testing.log'
        }
      end
      before do
        RabbitmqClient.instance_variable_set(:@logger, nil)
        RabbitmqClient.configure do |config|
          config.logger_configs = logger_configs
        end
      end

      it 'create file logger' do
        logger = RabbitmqClient.logger
        logdev = logger.instance_variable_get(:@logdev)
        dev = logdev.instance_variable_get(:@dev)
        expect(RabbitmqClient.config.logger_configs).to eq(logger_configs)
        expect(logger.level).to eq(0)
        expect(logger).to be_kind_of(Logger)
        expect(dev.inspect).to eq('#<File:testing.log>')
      end
    end
  end
end

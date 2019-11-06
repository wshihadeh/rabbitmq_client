# frozen_string_literal: true

require 'spec_helper'

class EmptyRabbitmqClientPlugin < RabbitmqClient::Plugin
end

describe EmptyRabbitmqClientPlugin do
  it 'raise an EmptyPlugin error' do
    expect { described_class.new }.to raise_error(RabbitmqClient::EmptyPlugin)
  end
end

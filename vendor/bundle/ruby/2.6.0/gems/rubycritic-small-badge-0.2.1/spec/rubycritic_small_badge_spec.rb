# frozen_string_literal: true

require 'spec_helper'

describe RubyCriticSmallBadge do
  describe '#configure' do
    context 'set config' do
      it do
        described_class.configure do |config|
          config.score_font = 'TestFont'
        end
        expect(described_class.config.score_font).to eq 'TestFont'
      end
    end

    context 'wrong config' do
      it do
        expect do
          described_class.configure do |config|
            config.wrong_value = 'test12'
          end
        end.to raise_error(NoMethodError)
      end
    end
  end
end

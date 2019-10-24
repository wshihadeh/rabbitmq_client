# frozen_string_literal: true

require 'spec_helper'

describe RubyCriticSmallBadge::Report do
  include TestRubyCriticSmallBadge::Mocks

  describe '#generate_report' do
    context 'bad result' do
      subject { described_class.new(mock_analysed_modules(50.0)) }
      it do
        allow(RubyCriticSmallBadge.config).to receive(:minimum_score)
          .and_return(90.0)
        mock_repo_badge_image(score: '50.0/100.0', state: 'bad')
        expect(subject.generate_report).to be_truthy
      end
    end

    context 'good result' do
      subject { described_class.new(mock_analysed_modules(100.0)) }
      it do
        allow(RubyCriticSmallBadge.config).to receive(:minimum_score)
          .and_return(90.0)
        mock_repo_badge_image(score: '100.0/100.0')
        expect(subject.generate_report).to be_truthy
      end
    end

    context 'unknown result' do
      subject { described_class.new(mock_analysed_modules(100.0)) }
      it do
        mock_repo_badge_image(score: '100.0/100.0', state: 'unknown')
        expect(subject.generate_report).to be_truthy
      end
    end
  end
end

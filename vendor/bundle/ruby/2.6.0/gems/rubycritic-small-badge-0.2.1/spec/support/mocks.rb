# frozen_string_literal: true

module RubyCritic
  class Rating
  end
end

module TestRubyCriticSmallBadge
  module Mocks
    # rubocop:disable Metrics/ParameterLists, Metrics/AbcSize
    def mock_repo_badge_image(score: 100, name: 'score',
                              title: 'score',
                              state: 'good',
                              config: {},
                              mock: instance_double('Image'))
      config = map_config_options(config, state)
      allow(RepoSmallBadge::Image).to receive(:new)
        .with(config).and_return(mock)
      allow(mock).to receive(:config_merge).with(config).and_return(config)
      allow(mock).to receive(:badge).with(name, title, score)
      mock
    end
    # rubocop:enable Metrics/ParameterLists, Metrics/AbcSize

    def map_config_options(config_hash, state)
      hash = {}
      RubyCriticSmallBadge::Configuration.options.merge(config_hash)
                                         .map do |key, value|
        key = key.to_s
                 .sub(/^score_background_#{state}/, 'value_background')
                 .to_sym
        key = key.to_s.sub(/^score_/, 'value_').to_sym
        hash[key] = value
      end
      hash
    end

    def mock_analysed_modules(score = 100.0)
      analysed_mod_double = instance_double('RubyCritic::AnalysedModules')
      allow(analysed_mod_double)
        .to receive('score')
        .and_return(score)
      analysed_mod_double
    end
  end
end

# frozen_string_literal: true

require 'repo_small_badge/image'
require 'rubycritic_small_badge/configuration'

module RubyCriticSmallBadge
  # Basic Badge Formater Class that creates the badges.
  class Report
    def initialize(analysed_modules)
      @config = RubyCriticSmallBadge.config
      @analysed_modules = analysed_modules
    end

    def generate_report
      mk_output_dir!
      score =  @analysed_modules.score
      @image = RepoSmallBadge::Image.new(map_image_config(state(score)))
      badge('score', 'score', score)
      true
    end

    private

    def max_score
      100.0
    end

    def mk_output_dir!
      FileUtils.mkdir_p(@config.output_path)
    end

    def badge(name, title, score)
      value_txt = score_text(score)
      @image.config_merge(map_image_config(state(score)))
      @image.badge(name, title, value_txt)
    end

    def score_text(score)
      "#{score}/#{max_score}"
    end

    def state(value)
      if @config.minimum_score&.positive?
        if value >= @config.minimum_score
          'good'
        else
          'bad'
        end
      else
        'unknown'
      end
    end

    def map_image_config(state)
      hash = {}
      @config.to_hash.map do |key, value|
        key = key
              .to_s.sub(/^score_background_#{state}/, 'value_background')
              .to_sym
        key = key.to_s.sub(/^score_/, 'value_').to_sym
        hash[key] = value
      end
      hash
    end
  end
end

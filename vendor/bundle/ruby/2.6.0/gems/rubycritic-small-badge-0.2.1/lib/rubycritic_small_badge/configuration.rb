# frozen_string_literal: true

module RubyCriticSmallBadge
  # Class to keep all the valid documentations that are required to build the
  # badge
  class Configuration
    # Set up config variables.
    # rubocop:disable Metrics/MethodLength
    def self.options
      {
        with_analysers: false,
        background: '#fff',
        title_prefix: 'rubycritic',
        title_background: '#555',
        title_font: 'Verdana,sans-serif',
        title_font_color: '#fff',
        score_background_bad: '#ff0000',
        score_background_unknown: '#cccc00',
        score_background_good: '#4dc71f',
        score_font: 'Verdana,sans-serif',
        score_font_color: '#fff',
        font: 'Verdana,sans-serif',
        font_size: 11,
        badge_height: 20,
        badge_width: 200,
        filename_prefix: 'rubycritic_badge',
        output_path: 'badges',
        rounded_border: true,
        rounded_edge_radius: 3,
        minimum_score: nil
      }
    end
    # rubocop:enable Metrics/MethodLength

    # set up class variables and getters/setters
    options.keys.each do |opt|
      define_method(opt) { instance_variable_get "@#{opt}" }
      define_method("#{opt}=") { |val| instance_variable_set("@#{opt}", val) }
    end

    def initialize(**opts)
      RubyCriticSmallBadge::Configuration
        .options.merge(opts).each { |opt, v| send(:"#{opt}=", v) }
    end

    def to_hash
      hash = {}
      instance_variables.each do |var|
        hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
      end
      hash
    end
  end
end

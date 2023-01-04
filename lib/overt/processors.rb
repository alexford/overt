# frozen_string_literal: true

module Overt
  module Processors
    DEFAULT_PROCESSORS = [].freeze

    @pre_processors = DEFAULT_PROCESSORS.dup
    attr_reader :pre_processors

    def self.add(processor)
      # TODO: post processors
      @pre_processors << processor
    end

    def self.run(site, console:)
      # TODO: post processors
      @pre_processors.each do |processor|
        console.line "- Running #{processor}"
        processor.new(site, console:).call
        console.line ''
      end
    end

    def self.load
      Dir['./overt/*.rb'].each { |file| require file }
    end
  end
end

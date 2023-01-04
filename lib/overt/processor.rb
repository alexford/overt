# frozen_string_literal: true

module Overt
  class Processor
    def initialize(site, console:)
      @site = site
      @console = console
    end

    def call; end

    private

    attr_reader :console
  end
end

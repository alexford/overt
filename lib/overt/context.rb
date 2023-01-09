# frozen_string_literal: true

module Overt
  class MissingPartialError < StandardError; end

  class Context
    include FileTools
    attr_accessor :meta
    attr_reader :page

    def initialize(page)
      @page = page
      @meta = {}
    end

    def overt_version
      Overt::VERSION
    end

    def site
      @page.site
    end

    def partial(name)
      partial_file = source_glob("**/_#{name}*", @page.site.source_dir)[0]
      raise MissingPartialError, "Can't find partial '_#{name}'" unless partial_file

      Tilt.new(partial_file).render(self)
    end
  end
end

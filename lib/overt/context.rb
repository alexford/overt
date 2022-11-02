# frozen_string_literal: true

module Overt
  class Context
    include FileHelpers

    def initialize(site)
      @site = site
    end

    def overt_version
      Overt::VERSION
    end

    def partial(name)
      partial_file = source_glob("**/_#{name}*", @site.source_dir)[0]
      raise MissingPartialError, "Can't find partial '_#{name}'" unless partial_file

      Tilt.new(partial_file).render(self)
    end
  end
end

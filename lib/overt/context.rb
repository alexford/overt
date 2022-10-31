# frozen_string_literal: true

module Overt
  class Context
    def overt_version
      Overt::VERSION
    end

    def partial(name)
      partial_file = Overt.source_glob("**/_#{name}*")[0]
      raise MissingPartialError, "Can't find partial '_#{name}'" unless partial_file

      Tilt.new(partial_file).render(self)
    end
  end
end

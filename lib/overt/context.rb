module Overt
  class Context
    def overt_version
      Overt::VERSION
    end
    
    def partial(name)
      partial_file = Overt.source_glob("**/_#{name}*")[0]
      if partial_file
        Tilt.new(partial_file).render(self)
      else
        raise MissingPartialError.new("Can't find partial '_#{name}'")
      end
    end
  end
end
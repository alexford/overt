# frozen_string_literal: true

module Overt
  class ConsoleOutput
    def f
      @f ||= Formatador.new
    end

    def quiet!
      @quiet = true
    end

    def line(string)
      f.display_line(string) unless @quiet
    end

    def reline(string)
      f.redisplay(string) unless @quiet
    end

    def table(*args)
      f.display_table(*args) unless @quiet
    end
  end
end

module Overt
  module ConsoleOutput
    def f
      @f ||= Formatador.new
    end
  end
end
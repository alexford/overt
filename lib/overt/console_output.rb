module Overt
  class ConsoleOutput
    def f
      @f ||= Formatador.new
    end
    
    def quiet(q = true)
      @quiet = q
    end
    
    def line(string)
      if !@quiet then f.display_line(string) end
    end
    
    def reline(string)
      if !@quiet then f.redisplay(string) end
    end

    def table(*args)
      if !@quiet then f.display_table(*args) end
    end
  end
end
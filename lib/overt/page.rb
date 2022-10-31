module Overt
  class Page
    def initialize(source_template, layout, context = Overt::Context.new)
      @source_template = source_template
      @layout = layout
      @context = context
    end
    
    def html
      @html ||= @layout.render(@context) { Tilt.new(@source_template).render(@context) }
    end
  end
end
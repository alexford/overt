# frozen_string_literal: true

module Overt
  class Page
    def initialize(source_template, layout_template, context = Overt::Context.new)
      @source_template = source_template
      @layout_template = layout_template
      @context = context
    end

    def html
      @html ||= @layout_template.render(@context) { Tilt.new(@source_template).render(@context) }
    end
  end
end

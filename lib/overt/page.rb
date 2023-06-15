# frozen_string_literal: true

module Overt
  class Page < Overt::SourceFile
    attr_reader :context, :layout_template

    def initialize(site, source_pathname, layout_template)
      @layout_template = layout_template
      @context = Overt::Context.new(self)
      super(site, source_pathname)
    end

    def build_extension
      '.html'
    end

    def html
      @html ||= begin
        inner_html = template_html
        @layout_template.render(@context) { inner_html }
      end
    end

    private

    def template_html
      @template_html ||= Tilt.new(@source_pathname, smartypants: true).render(@context)
    end
  end
end

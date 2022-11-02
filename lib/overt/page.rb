# frozen_string_literal: true

module Overt
  class Page
    attr_reader :source_pathname, :site, :context

    def initialize(site, source_pathname, layout_template)
      @source_pathname = source_pathname
      @layout_template = layout_template
      @context = Overt::Context.new(self)
      @site = site
    end

    def html
      @html ||= begin
        inner_html = template_html
        @layout_template.render(@context) { inner_html }
      end
    end

    def extension
      # TODO: other extensions possible?
      '.html'
    end

    def relative_build_pathname
      file_name = File.basename(source_pathname, File.extname(source_pathname)) + extension
      build_path = relative_source_pathname.dirname

      Pathname.new File.join(build_path, file_name)
    end

    def relative_source_pathname(source_dir = @site.source_dir)
      @source_pathname.relative_path_from(source_dir)
    end

    private

    def template_html
      @template_html ||= Tilt.new(@source_pathname).render(@context)
    end
  end
end

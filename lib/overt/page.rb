# frozen_string_literal: true

module Overt
  class Page
    attr_reader :source_pathname

    def initialize(site, source_pathname, layout_template, context)
      @source_pathname = source_pathname
      @layout_template = layout_template
      @context = context
      @site = site
    end

    def html
      @html ||= @layout_template.render(@context) { Tilt.new(@source_pathname).render(@context) }
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
  end
end

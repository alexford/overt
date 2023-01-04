# frozen_string_literal: true

module Overt
  class Site
    include FileTools
    attr_reader :source_dir

    def initialize(source_dir)
      @source_dir = source_dir
    end

    def pages
      @pages ||= page_source_pathnames.map do |source_pathname|
        Page.new(self, source_pathname, layout_template)
      end
    end

    def static_files
      @static_files ||= static_file_source_pathnames.map do |source_pathname|
        StaticFile.new(self, source_pathname)
      end
    end

    private

    def layout_template
      @layout_template ||= begin
        layout_candidates = source_glob('_layout.*', source_dir)

        if layout_candidates.length.positive? && File.exist?(layout_candidates[0])
          Tilt.new(layout_candidates[0])
        else
          Tilt::ERBTemplate.new { '<%= yield %>' }
        end
      end
    end

    def page_source_pathnames
      @page_source_pathnames ||= Dir[File.join(@source_dir, '**/[!_]*.*{erb,md}')].map { |path| Pathname.new(path) }
    end

    def static_file_source_pathnames
      @static_file_source_pathnames ||= Dir[File.join(@source_dir, '**/[!_]*.*')]
        .map { |path| Pathname.new(path) } - page_source_pathnames
    end
  end
end

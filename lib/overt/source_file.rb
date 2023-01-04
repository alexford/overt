# frozen_string_literal: true

module Overt
  class SourceFile
    attr_reader :source_pathname, :site

    def initialize(site, source_pathname)
      @source_pathname = source_pathname
      @site = site
    end

    def relative_build_pathname
      file_name = File.basename(source_pathname, File.extname(source_pathname)) + build_extension
      build_path = relative_source_pathname.dirname

      Pathname.new File.join(build_path, file_name)
    end

    def relative_source_pathname(source_dir = @site.source_dir)
      @source_pathname.relative_path_from(source_dir)
    end
  end
end

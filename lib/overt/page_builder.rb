# frozen_string_literal: true

module Overt
  class PageBuilder
    def initialize(page, build_dir:)
      @page = page
      @build_dir = build_dir
    end

    def build!
      absolute_build_file_path.dirname.mkpath
      File.write(absolute_build_file_path, @page.html)
    end

    private

    def absolute_build_file_path
      Pathname.new File.join(@build_dir, @page.relative_build_pathname)
    end
  end
end

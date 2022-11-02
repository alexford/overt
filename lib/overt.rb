# frozen_string_literal: true

require 'overt/version'
require 'overt/file_helpers'
require 'overt/context'
require 'overt/site'
require 'overt/page'
require 'overt/console_output'
require 'overt/errors'
require 'tilt'
require 'pathname'
require 'fileutils'

module Overt
  def self.clean(build_dir)
    files = Dir[File.join(build_dir, '**/*')]

    FileUtils.rm_rf files
  end

  def self.build(source_dir:, build_dir:, console:)
    site = Overt::Site.new(source_dir)

    site.pages.each_with_index do |page, i|
      build_pathname = absolute_build_file_path(page.relative_build_pathname, build_dir)
      console.line "+ writing (#{i + 1}/#{site.pages.length}): #{page.source_pathname} as #{build_pathname}"
      write_page!(page, build_pathname)
    end
  end

  def self.write_page!(page, output_file)
    output_file.dirname.mkpath
    File.write(output_file, page.html)
  end

  def self.absolute_build_file_path(relative_build_pathname, build_dir)
    Pathname.new File.join(build_dir, relative_build_pathname)
  end
end

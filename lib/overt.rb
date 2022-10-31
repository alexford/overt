# frozen_string_literal: true

require 'overt/version'
require 'overt/context'
require 'overt/page'
require 'overt/console_output'
require 'overt/errors'
require 'tilt'
require 'pathname'
require 'fileutils'

module Overt
  CONFIG = {
    source_dir: ENV['OVERT_SOURCE_DIR'] || 'src',
    build_dir: ENV['OVERT_BUILD_DIR'] || 'public'
  }.freeze

  def self.clean
    files = Dir[File.join(CONFIG[:build_dir], '**/*')]

    FileUtils.rm_rf files
  end

  # TODO: lots of refactoring
  def self.build(console:)
    context = Context.new

    source_pathnames.each_with_index do |source_pathname, i|
      build_pathname = build_pathname_for_source(source_pathname)
      console.line "+ writing (#{i + 1}/#{source_pathnames.length}): #{source_pathname} as #{build_pathname}"

      page = Page.new(source_pathname, layout_template, context)
      write_page!(page, build_pathname)
    end
  end

  def self.layout_template
    @layout_template ||= begin
      layout_candidates = source_glob('_layout.*')

      if layout_candidates.length.positive? && File.exist?(layout_candidates[0])
        Tilt.new(layout_candidates[0])
      else
        Tilt::ERBTemplate.new { '<%= yield %>' }
      end
    end
  end

  def self.write_page!(page, output_file)
    output_file.dirname.mkpath
    File.open output_file, 'w' do |file|
      file.write page.html
    end
  end

  def self.source_pathnames
    @source_pathnames ||= Dir[File.join(CONFIG[:source_dir], '**/[!_]*.*')].map { |path| Pathname.new(path) }
  end

  def self.build_pathname_for_source(source_pathname, extension = '.html')
    file_name = File.basename(source_pathname, File.extname(source_pathname)) + extension
    build_path = build_file_path(source_pathname.relative_path_from(CONFIG[:source_dir]).dirname)

    Pathname.new(File.join(build_path, file_name))
  end

  def self.build_file_path(name)
    File.join(CONFIG[:build_dir], name)
  end

  def self.source_glob(glob)
    Dir[File.join(CONFIG[:source_dir], glob)]
  end
end

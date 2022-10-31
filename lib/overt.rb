# frozen_string_literal: true

require "overt/version"
require "overt/context"
require "overt/console_output"
require "overt/errors"
require "tilt"
require "pathname"
require "fileutils"

module Overt
  Config = {
    source_dir: ENV['OVERT_SOURCE_DIR'] || 'src',
    build_dir: ENV['OVERT_BUILD_DIR'] || 'public'
  }
  
  def self.clean
    files = Dir[File.join(Config[:build_dir], "**/*")]

    FileUtils.rm_rf files
  end
  
  # TODO: lots of refactoring
  def self.build(console:)
    context = Context.new

    source_pathnames.each_with_index do |source_pathname, i|
      build_pathname = build_pathname_for_source(source_pathname)
      console.line "+ building (#{i+1}/#{source_pathnames.length}): #{source_pathname} to #{build_pathname}"
  
      build_pathname.dirname.mkpath
      
      File.open build_pathname, 'w' do |build_file|
        build_file.write layout_template.render(context) {
          Tilt.new(source_pathname).render
        }
      end
    end
  end
  
  private
  
  def self.layout_template
    @layout_template ||= begin
      layout_candidates = source_glob("_layout.*")
    
      if layout_candidates.length > 0 && File.exists?(layout_candidates[0])
        Tilt.new(layout_candidates[0])
      else
        Tilt::ERBTemplate.new { "<%= yield %>" }
      end
    end
  end
  
  def self.source_pathnames
    @source_pathnames ||= Dir[File.join(Config[:source_dir], "**/[!_]*.*")].map { |path| Pathname.new(path) }
  end
  
  def self.build_pathname_for_source(source_pathname, extension = '.html')
    file_name = File.basename(source_pathname, File.extname(source_pathname)) + extension
    build_path = build_file(source_pathname.relative_path_from(Config[:source_dir]).dirname)

    Pathname.new(File.join(build_path, file_name))
  end
  
  def self.source_file(name)
    File.join(Config[:source_dir], name)
  end
  
  def self.build_file(name)
    File.join(Config[:build_dir], name)
  end
  
  def self.source_glob(glob)
    Dir[File.join(Config[:source_dir], glob)]
  end
end
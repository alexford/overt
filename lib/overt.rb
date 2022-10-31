# frozen_string_literal: true

require "overt/version"
require "overt/context"
require "overt/console_output"
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
  def self.build(f)
    context = Context.new

    source_pathnames.each do |source_pathname|
      build_pathname = build_pathname_for_source(source_pathname)
      f.display_line "+ building #{source_pathname} to #{build_pathname}"
  
      build_pathname.dirname.mkpath
      
      File.open build_pathname, 'w' do |file|
          file.write layout_template.render(context) {
              Tilt::ERBTemplate.new(source_pathname).render
          }
      end
    end
  end
  
  private
  
  def self.layout_template
    @layout_template ||= begin
      if File.exists?(source_file("_layout.html.erb"))
        Tilt::ERBTemplate.new(source_file("_layout.html.erb"))
      else
        Tilt::ERBTemplate.new { "<%= yield %>" }
      end
    end
  end
  
  def self.source_pathnames
    @source_pathnames ||= Dir[File.join(Config[:source_dir], "**/[!_]*.erb")].map { |path| Pathname.new(path) }
  end
  
  def self.build_pathname_for_source(source_pathname)
    Pathname.new(build_file(source_pathname.relative_path_from(Config[:source_dir])).sub('.erb', ''))
  end
  
  def self.source_file(name)
    File.join(Config[:source_dir], name)
  end
  
  def self.build_file(name)
    File.join(Config[:build_dir], name)
  end
end
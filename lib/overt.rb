# frozen_string_literal: true

# TODO: zeitwerk or something
require 'overt/version'
require 'overt/file_tools'
require 'overt/context'
require 'overt/site'
require 'overt/source_file'
require 'overt/source_files/page'
require 'overt/source_files/static_file'
require 'overt/page_builder'
require 'overt/console_output'
require 'overt/processor'
require 'overt/processors'
require 'overt/errors'
require 'tilt'
require 'pathname'
require 'fileutils'
require 'async'
require 'async/barrier'

module Overt
  def self.clean(build_dir)
    files = Dir[File.join(build_dir, '**/*')]

    FileUtils.rm_rf files
  end

  def self.build(source_dir:, build_dir:, console:)
    site = Overt::Site.new(source_dir)

    preprocess(site, console:)

    static_files = site.static_files
    total = static_files.length
    console.line("[bold]Copying #{total} static files[/]\n")

    static_files.each_with_index do |file, i|
      console.line "+ copying (#{i + 1}/#{total}): #{file.source_pathname} as #{file.relative_build_pathname}"
      copy_static_file(file, build_dir)
    end
    console.line('')


    total = site.pages.length
    console.line("[bold]Building #{total} pages[/]\n")

    Async do
      site.pages.each_with_index do |page, i|
        console.line "+ writing (#{i + 1}/#{total}): #{page.source_pathname} as #{page.relative_build_pathname}"
        build_page(page, build_dir)
      end
    end.wait

    site
  end

  def self.preprocess(site, console:)
    console.line("[bold]Running pre-processors[/]\n")
    Processors.load
    Processors.run(site, console:)
    console.line('')
  end

  def self.copy_static_file(file, build_dir)
    Async do
      FileUtils.cp(file.source_pathname, File.join(build_dir, file.relative_build_pathname))
    end
  end

  def self.build_page(page, build_dir)
    Async do
      PageBuilder.new(page, build_dir:).build!
    end
  end
end

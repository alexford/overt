# frozen_string_literal: true

require 'overt/version'
require 'overt/file_helpers'
require 'overt/context'
require 'overt/site'
require 'overt/page'
require 'overt/page_builder'
require 'overt/console_output'
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
    total = site.pages.length

    Async do
      site.pages.each_with_index do |page, i|
        console.line "+ writing (#{i + 1}/#{total}): #{page.source_pathname} as #{page.relative_build_pathname}"
        build_page(page, build_dir)
      end
    end.wait

    site
  end

  def self.build_page(page, build_dir)
    Async do
      Overt::PageBuilder.new(page, build_dir:).build!
    end
  end
end

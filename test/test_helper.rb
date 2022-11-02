# frozen_string_literal: true

require "pry"

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "overt"

require "minitest/autorun"
require "minitest/spec"

def fixtured_page_template(file)
  Pathname.new File.join("test/fixtures/source_dir", file)
end

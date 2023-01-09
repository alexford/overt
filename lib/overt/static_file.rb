# frozen_string_literal: true

module Overt
  class StaticFile < Overt::SourceFile
    def build_extension
      File.extname(source_pathname)
    end
  end
end

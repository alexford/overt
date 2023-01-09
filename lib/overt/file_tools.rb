# frozen_string_literal: true

module Overt
  module FileTools
    def build_file_path(name, build_dir)
      File.join(build_dir, name)
    end

    def source_glob(glob, source_dir)
      Dir[File.join(source_dir, glob)]
    end
  end
end

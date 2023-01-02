# frozen_string_literal: true

require "test_helper"

describe Overt::Site do
  before do
    @site = Overt::Site.new('test/fixtures/source_dir')
  end

  describe "#pages" do
    it "is an array of Overt::Page elements derived from files in source_dir" do
      pages = @site.pages
      pages.each { |p| assert_instance_of Overt::Page, p }

      page_paths = pages.map { |p| p.relative_source_pathname.to_s }

      assert_equal([
                     "page.erb",
                     "page_needing_context.erb",
                     "page_with_meta_content.erb",
                     "subdirectory/subpage.erb"
                   ], page_paths)
    end

    it "uses _layout file in source_dir as layout_template for pages" do
      @site.pages.each do |p|
        assert_equal("test/fixtures/source_dir/_layout.erb", p.layout_template.file)
      end
    end

    it "sets `site` to self on each page" do
      @site.pages.each do |p|
        assert_equal p.site, @site
      end
    end
  end
end

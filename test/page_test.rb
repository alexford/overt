# frozen_string_literal: true

require "test_helper"

describe Overt::Page do
  before do
    @site = Overt::Site.new('test/fixtures/source_dir')
    @layout = Tilt::ERBTemplate.new('test/fixtures/source_dir/_layout.erb')
  end

  describe '#context' do
    it 'is an Overt::Context for this Page' do
      page = Overt::Page.new(@site, fixtured_page_template("page.erb"), @layout)
      context = page.context

      assert_instance_of Overt::Context, context
      assert_equal context.page, page
    end
  end

  describe '#html' do
    it "returns the rendered ERB template passed as filename, with layout" do
      page = Overt::Page.new(@site, fixtured_page_template("page.erb"), @layout)

      assert_equal(
        "<html><title>Layout!</title><body><strong>Hello from the page template!</strong>\n\n2</body></html>\n",
        page.html
      )
    end

    it "returns the rendered Markdown template passed as filename, with layout" do
      page = Overt::Page.new(@site, fixtured_page_template("page.md"), @layout)

      assert_equal(
        "<html><title>Layout!</title><body><h1>Hello from the markdown template!</h1>\n</body></html>\n",
        page.html
      )
    end

    it "renders the template with an Overt::Context for the page" do
      page = Overt::Page.new(@site, fixtured_page_template("page_needing_context.erb"), @layout)

      assert_instance_of Overt::Context, page.context
      assert_match Overt::VERSION, page.html
    end

    describe "shared content (meta hash)" do
      it "is available to the layout template when set in the page template" do
        page = Overt::Page.new(@site, fixtured_page_template("page_with_meta_content.erb"), @layout)
        html = page.html

        assert_equal "Title from page template!", page.context.meta[:title]
        assert_match "<title>Title from page template!</title>", html
      end
    end

  end

  describe '#relative_build_pathname' do
    it "is the path/filename for the page relative to the build_dir" do
      page = Overt::Page.new(@site, fixtured_page_template("/subdirectory/subpage.erb"), @layout)

      assert_equal 'subdirectory/subpage.html', page.relative_build_pathname.to_s
    end
  end

  describe '#relative_source_pathname' do
    it "is the path/filename for the page template relative to the source_dir" do
      page = Overt::Page.new(@site, fixtured_page_template("/subdirectory/subpage.erb"), @layout)

      assert_equal 'subdirectory/subpage.erb', page.relative_source_pathname.to_s
    end
  end
end

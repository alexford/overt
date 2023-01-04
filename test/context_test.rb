# frozen_string_literal: true

require "test_helper"

describe Overt::Context do
  before do
    @site = Overt::Site.new('test/fixtures/source_dir')
    @page = @site.pages[0]
    @context = Overt::Context.new(@page)
  end

  describe '#site' do
    it 'is the Site referenced by the Page' do
      assert_equal @context.site, @page.site
    end
  end

  describe '#page' do
    it "is the page given in the initializer"
      assert_equal @context.page, @page
    end
  end

  describe '#overt_version' do
    it 'is Overt::VERSION' do
      assert_equal @context.overt_version, Overt::VERSION
    end
  end

  describe '#partial' do
    it "returns the rendered content of the named partial" do
      rendered_partial = @context.partial('partial')

      assert_match 'A partial!', rendered_partial
    end

    it "passes self as the context for the render" do
      @context.meta[:foo] = 'bar'
      rendered_partial = @context.partial('partial')

      assert_match 'meta[:foo] is bar', rendered_partial
    end

    it "raises Overt::MissingPartialError if partial cannot be found" do
      error = assert_raises Overt::MissingPartialError do
        @context.partial('foo')
      end
      assert_equal "Can't find partial '_foo'", error.message
    end
  end
end

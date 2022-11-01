# frozen_string_literal: true

require "test_helper"

describe Overt::Page do
  before do
    @layout = Tilt::ERBTemplate.new { "<html><body><title>Layout!</title><%= yield %></body></html>" }
  end

  describe '#html' do
    it "returns the rendered template passed as filename, with layout" do
      page = Overt::Page.new("test/fixtures/page.erb", @layout)
      assert_equal page.html,
                   "<html><body><title>Layout!</title><strong>Hello from the page template!</strong>\n\n2</body></html>"
    end

    it "renders the template with an Overt::Context as the context if no context is given" do
      page = Overt::Page.new("test/fixtures/page_needing_context.erb", @layout)
      assert_match Overt::VERSION, page.html
    end

    it "renders the template with given object as the context" do
      context = Object.new
      context.define_singleton_method(:overt_version) do
        "Foo version!"
      end

      page = Overt::Page.new("test/fixtures/page_needing_context.erb", @layout, context)
      assert_match "Foo version!", page.html
    end
  end
end

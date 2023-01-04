# frozen_string_literal: true

class DummyProcessor < Overt::Processor
  def call
    @console.line 'DummyProcessor called'
  end
end

Overt::Processors.add DummyProcessor

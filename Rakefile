# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb'] # optional
  t.options = ['-odocs'] # optional
end

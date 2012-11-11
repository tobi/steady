#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'bundler'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.libs << '.' << 'lib' << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
end


# frozen_string_literal: true

# Copyright (c) 2018-2020, Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

require_relative 'test/fixtures'

OPENMPT_CMD = 'openmpt123 --batch --quiet --end-time 10'
RAW_PCM_FILES = [
  RAW_LAST_SUN_INT16,
  RAW_LAST_SUN_FLOAT
]

task default: :test

RAW_PCM_FILES.each do |pcm|
  file pcm => [MOD_LAST_SUN] do |t|
    float = pcm.include?('float') ? '--float' : '--no-float'
    sh "#{OPENMPT_CMD} #{float} --output #{t.name} #{t.prerequisites[0]}"
  end
end

Rake::TestTask.new(:test) do |t|
  t.deps = RAW_PCM_FILES
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

RuboCop::RakeTask.new

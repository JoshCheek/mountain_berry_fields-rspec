#!/usr/bin/env rake
require 'bundler/setup'

desc 'Run rspecs'
task :spec do
  sh 'rspec'
end

desc 'Run Cukes not marked as wip'
task :cucumber do
  sh 'cucumber --tags ~@wip'
end

namespace :cucumber do
  desc 'Run cukes marked as wip'
  task :wip do
    sh 'cucumber --tags @wip'
  end
end

task default: [:spec, :cucumber]

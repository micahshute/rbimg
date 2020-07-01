require "bundler/gem_tasks"
require "rspec/core/rake_task"
spec = Gem::Specification.find_by_name 'gspec'
load "#{spec.gem_dir}/lib/gspec/tasks/generator.rake"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Open interactive console for this project"
task :console do 
    require 'pry'
    require_relative './lib/rbimg'
    Pry.start
end
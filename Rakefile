require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: :test

##
# Github Actions always sets ENV["CI"] to true, so we can depend on it to prevent
# standardrb from running with the "--fix" flag.
#
# @see
#   https://docs.github.com/en/actions/reference/environment-variables#default-environment-variables
task :lint do
  if ENV["CI"]
    sh "bin/standardrb"
  else
    sh "bin/standardrb --fix"
  end
end

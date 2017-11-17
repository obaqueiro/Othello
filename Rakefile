require 'rake/testtask'

task default: %w[test]

task :run do
  ruby './bin/Othello'
end

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end

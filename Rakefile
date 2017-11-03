task default: %w[test]

task :run do
  ruby "./bin/othello"
end

task :win do
  ruby "./lib/window.rb"
end

multitask :gui => [:win, :run] do
end
task :test do
  ruby "./tests/Othello_tests.rb"
end

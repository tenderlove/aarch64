require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test/lib" << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
end

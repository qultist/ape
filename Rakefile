task default: %w[build]

desc "Run tests"
task :test do
	mkdir_p 'test-results'
	sh %(swift test --parallel --xunit-output test-results/results.xml)
end

desc "Create code coverage report"
task :codecov do
	mkdir_p 'codecov'
	sh %(swift test --enable-code-coverage)
	sh %(./scripts/llvm-codecov.sh > codecov/report)
end

desc "Build ape"
task :build do
	sh %(swift build -c release --disable-sandbox)
	sh %(mv .build/release/Ape .build/release/ape)
end

desc "Install ape in /usr/local/bin"
task :install => :build do
	cp '.build/release/ape', '/usr/local/bin/ape'
end

desc "Delete the build directory"
task :clean do
	rm_rf '.build'
end

task default: %w[build]

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

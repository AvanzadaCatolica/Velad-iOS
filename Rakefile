desc "Bootstraps this project"
task :bootstrap do
  system "bundle exec pod install"
  system "carthage update"
end

desc "Run tests"
task :test do
  system "xcodebuild -workspace Velad.xcworkspace -scheme UnitTests -sdk iphonesimulator -destination platform='iOS Simulator',OS=9.0,name='iPhone 5s' test"  
end

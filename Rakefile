desc "Bootstraps this project"
task :bootstrap do
  system "bundle exec pod install"
  system "carthage update"
end

desc "Packs ipa"
task :pack do
  system "xcodebuild -workspace Velad.xcworkspace -scheme Velad -archivePath build/Velad.xcarchive archive"
  system "xcrun xcodebuild -exportArchive -exportOptionsPlist export-options.plist -archivePath build/Velad.xcarchive -exportPath build/"
end

desc "Run tests"
task :test do
  
end

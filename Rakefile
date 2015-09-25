desc "Bootstraps this project"
task :bootstrap do
  system "bundle exec pod install"
  system "carthage update"
end

namespace :test do

  desc "Run unit tests"
  task :unit do
    system "xcodebuild -workspace Velad.xcworkspace -scheme UnitTests -sdk iphonesimulator -destination platform='iOS Simulator',OS=9.0,name='iPhone 5s' test"  
  end

  desc "Run snapshot tests"
  task :snapshot do
    system "xcodebuild -workspace Velad.xcworkspace -scheme SnapshotTests -sdk iphonesimulator -destination platform='iOS Simulator',OS=9.0,name='iPhone 5s' test"
  end

end

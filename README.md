Velad
=====

[![Build Status](https://travis-ci.org/AvanzadaCatolica/Velad-iOS.svg?branch=master)](https://travis-ci.org/AvanzadaCatolica/Velad-iOS)

__Description:__

Please visit the [App Store]() for more information about this app.

__Source code:__

Velad is open source because we believe in the open source philosophy. If you would like to contribute to this project, please get in touch [with us](mailto:mlopez@avanzadacatolica.org) first.

__Requirements:__

Xcode 7 and Ruby 2.0 or higher.

__Building:__

Velad uses CocoaPods as dependency manager for the application target. In order to build this project, run:

```ruby
bundle install
bundle exec rake bootstrap
```

and open the `.xcworkspace` file with Xcode.

__Tests:__

Velad uses Carthage as dependency manager for the test target. In order to build the tests, run:

```ruby
bundle install
bundle exec rake tests
```

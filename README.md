Velad
=====

__Description:__

Velad brings an agile tool to do daily autoevaluations, allowing you to register your activities and showing advancement and spiritual growth indicators. Please visit the [App Store](https://itunes.apple.com/us/app/velad/id1046170047) for more information about this app.

__Source code:__

Velad is open source because we believe in the open source philosophy. If you would like to contribute to this project, please get in touch [with us](mailto:mlopez@avanzadacatolica.org) first.

__Requirements:__

* Xcode 7.1 (Swift 2.1)
* Ruby 2.0 or higher
* Carthage 0.10.0

__Building:__

Velad uses CocoaPods as dependency manager for the application target. In order to build this project, run:

```ruby
bundle install
bundle exec rake bootstrap:application
```

and open the `.xcworkspace` file with Xcode.

__Tests:__

Velad uses Carthage as dependency manager for the test targets and runs two different types of tests: unit tests, to test business logic; and snapshot tests, to test view consistency and layout code. In order to build the tests, run:

```ruby
bundle install
bundle exec rake bootstrap:tests
bundle exec rake tests:unit # unit tests
bundle exec rake tests:snapshot # snapshot tests
```

__Packing:__

In order to pack the project (generate the .ipa file) run:

```ruby
bundle install
bundle exec rake bootstrap:application
bundle exec rake pack
```

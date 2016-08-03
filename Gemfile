#run sudo gem install bundler -n /usr/local/bin if you need to update bundler
#if you get an error regarding rmagick run brew install ImageMagick , then brew remove --force pkg-config and brew install pkg-config
source "https://rubygems.org"
gem "cocoapods"
gem 'xcpretty'
gem 'fastlane', "~> 1.93"
gem 'danger'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval(File.read(plugins_path), binding) if File.exist?(plugins_path)

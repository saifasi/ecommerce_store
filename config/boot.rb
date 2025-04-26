ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require 'mutex_m'        # ensure ActiveSupport notifications thread safe
require 'logger'         # ensure LoggerThreadSafeLevel finds ::Logger
require "bundler/setup"  # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

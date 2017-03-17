$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rpd'
include Rpd

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!
reporter_options = { color: true }
#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
require File.expand_path("spec_helper", File.dirname(__FILE__))
require 'repim'

describe Repim do
  it{ Repim::Version.should =~ /\A\d+\.\d+\.\d+\Z/ }
end


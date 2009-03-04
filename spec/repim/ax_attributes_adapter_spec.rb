#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'repim/ax_attributes_adapter'

describe Repim::AxAttributeAdapter do
  before do
    @it = Repim::AxAttributeAdapter.new(%w[http://axscheme.org], :name => "/namePerson", :login => "/namePerson/friendly")
  end

  it{ @it.necessity.should == :optional }
  it{ @it.required!; @it.necessity.should == :required }
  it{ @it.should have(2).keys }
  it{ @it.keys.should include "http://axscheme.org/namePerson"  }

  describe "#adapt(response)" do
    before do
      @fetched = {
        "http://axscheme.org/namePerson" => "MOROHASHI Kyosuke",
        "http://scheme.openid.net/namePerson/friendly" => "moro",
      }
    end
    it{ @it.adapt(@fetched)[:name].should == "MOROHASHI Kyosuke" }
    it{ @it.adapt(@fetched)[:login].should be_nil }
  end
end


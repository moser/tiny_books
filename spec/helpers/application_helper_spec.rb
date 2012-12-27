# encoding: utf-8
require "spec_helper"

describe ApplicationHelper do
  describe "#format_currency" do
    it "returns a localized string" do
      helper.format_currency(1.0).should == "$1.00"
    end
  end
end
